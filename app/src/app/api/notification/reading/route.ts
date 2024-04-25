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
            "SELECT * FROM `view_reading_notifications` WHERE `user_id` = ? ORDER BY `issued_at` DESC",
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

export async function PATCH(request: NextRequest) {
    try {
        const { reading_notification_id } = await request.json();
        const connection = await getMySQLConnection();
        // read_at is mysql timestamp
        const [results, rows]: [results: any[], rows: any[]] = await connection.query(
            "UPDATE `reading_notifications` SET `isRead` = 1 WHERE `reading_notification_id` = ?",
            [reading_notification_id]
        );
        return NextResponse.json(
            { message: "Reading notification read"},
            {
                status: 200,
            },
        );
    } catch (err: any) {
        console.log(err)
        return NextResponse.json(
            { message: err?.message || "Something went wrong while updating the notification" },
            {
                status: 500,
            },
        );
    }
}