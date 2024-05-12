import getMySQLConnection from "@/db/mysql";
import getUserInfo from "@/utils/User";
import { cookies } from "next/headers";
import { NextRequest, NextResponse } from "next/server";

export async function GET(request: NextRequest) {
    try {
        const cookieToken = cookies().get('token')?.value;
        const connection = await getMySQLConnection();
        const { user_id } = await getUserInfo(cookieToken);
        const [results, rows]: [results: any[], rows: any[]] = await connection.query(
            "SELECT * FROM `view_user_water_quality_notifications` WHERE `user_id` = ?",
            [user_id]
        );
        console.log("TIMESTAMP", results[0].date_issued);
        return NextResponse.json(
            { results },
            {
                status: 200,
            },
        );
    } catch (err: any) {
        NextResponse.json({ message: err.message || "An error occurred" }, { status: 500 });
    }
}