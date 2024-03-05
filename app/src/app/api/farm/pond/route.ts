import getMySQLConnection from "@/db/mysql";
import { NextRequest, NextResponse } from "next/server";


export async function GET(request: NextRequest) {
    try {
        const farm_id = request.nextUrl.searchParams.get('farm_id');
        const connection = await getMySQLConnection();
        const [results, rows]: [results: any[], rows: any[]] = await connection.query(
            "SELECT * FROM `view_farmer_ponds` WHERE `farm_id` = ?",
            [farm_id]
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