import getMySQLConnection from "@/db/mysql";
import getUserInfo from "@/utils/User";
import { NextApiRequest } from "next";
import { cookies } from "next/headers";
import { NextRequest, NextResponse } from "next/server";


export async function GET(request: NextRequest) {
    try {
        const cookieToken = cookies().get('token')?.value;
        const connection = await getMySQLConnection();
        const { user_id } = await getUserInfo(cookieToken);
        const [results, rows]: [results: any[], rows: any[]] = await connection.query(
            "SELECT * FROM `user_notifications` WHERE `user_id` = ? ORDER BY `issued_at` DESC",
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
            { message: "Something went wrong while getting the notification" },
            {
                status: 500,
            },
        );
    }
}