import getMySQLConnection from "@/db/mysql";
import getUserInfo from "@/utils/User";
import { format } from "date-fns";
import { NextApiRequest } from "next";
import { cookies } from "next/headers";
import { NextRequest, NextResponse } from "next/server";

export async function POST(request: NextApiRequest) {
    try {
        const cookieToken = cookies().get('token')?.value;
        const connection = await getMySQLConnection();
        const { user_id } = await getUserInfo(cookieToken);
        const { farm, isOwner } = await new Response(request.body).json();
        const role = isOwner ? "OWNER" : "STAFF";
        const [results, rows]: [results: any, rows: any[]] = await connection.query(
            "INSERT INTO `farm_farmer` (`farmer_id`, `farm_id`, `role`) VALUES (?, ?, ?)",
            [user_id, farm.farm_id, role]
        );
        await connection.query(
            "INSERT INTO `user_notifications` (`user_id`, `action`, `message`) VALUES (?, ?, ?)",
            [user_id, "INFO", `You have been added as a ${role} to ${farm.name}, please wait for the farm owner's verification..`]
        );
        return NextResponse.json(
            { results },
            {
                status: 200,
            },
        );
    } catch (err: any) {
        console.log(err)
        return NextResponse.json(
            { message: "Something went wrong while entering farm details" },
            {
                status: 500,
            },
        );
    }
}