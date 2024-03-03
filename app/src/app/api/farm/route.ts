import getMySQLConnection from "@/db/mysql";
import { verify } from "@/utils/Jwt";
import getUserInfo from "@/utils/User";
import { NextApiRequest } from "next";
import { cookies } from "next/headers";
import { NextResponse } from "next/server";

export async function GET(request: NextApiRequest) {
    try {
        const cookieToken = cookies().get('token')?.value;
        const connection = await getMySQLConnection();
        const { user_id } = await getUserInfo(cookieToken);
        const [ results, rows ]: [ results: any[], rows: any[] ] = await connection.query(
            "SELECT `farm_id`, `name` FROM `farmer_farm_view` WHERE `user_id` = ?",
            [user_id]
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
            { message: "Something went wrong while getting the farm info" },
            {
                status: 500,
            },
        );
    }
}