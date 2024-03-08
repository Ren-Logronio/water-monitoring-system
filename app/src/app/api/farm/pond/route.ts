import getMySQLConnection from "@/db/mysql";
import getUserInfo from "@/utils/User";
import { cookies } from "next/headers";
import { NextRequest, NextResponse } from "next/server";


export async function GET(request: NextRequest) {
    try {
        const farm_id = request.nextUrl.searchParams.get('farm_id');
        const cookieToken = cookies().get('token')?.value;
        const { user_id } = await getUserInfo(cookieToken);
        const connection = await getMySQLConnection();
        const [results, rows]: [results: any[], rows: any[]] = await connection.query(
            "SELECT * FROM `view_farmer_ponds` WHERE `farm_id` = ? AND `user_id` = ?",
            [farm_id, user_id]
        );
        return NextResponse.json(
            { results },
            {
                status: 200,
            },
        );
    } catch (err: any) {
        return NextResponse.json(
            { message: "Something went wrong while getting the pond info" },
            {
                status: 500,
            },
        );
    }
}