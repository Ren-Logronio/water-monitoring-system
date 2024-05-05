import getMySQLConnection from "@/db/mysql";
import { NextRequest, NextResponse } from "next/server";

export async function GET(request: NextRequest){
    try {
        const connection = await getMySQLConnection();
        const farm_id = request.nextUrl.searchParams.get('farm_id');
        const [results, rows]: [results: any[], rows: any[]] = await connection.query(
            "SELECT * FROM `view_farm_reading_count` WHERE `farm_id` = ?",
            [farm_id]
        );
        return NextResponse.json(
            { results },
            {
                status: 200,
            },
        );
    } catch (error) {
        console.log(error);
        return NextResponse.json(
            { message: "Something went wrong while getting the readings count" },
            {
                status: 500,
            },
        );
    }
}