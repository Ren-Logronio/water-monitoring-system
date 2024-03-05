import getMySQLConnection from "@/db/mysql";
import { NextRequest, NextResponse } from "next/server";

export async function GET(request: NextRequest) {
    try {
        const connection = await getMySQLConnection();
        const [results, rows]: [results: any[], rows: any[]] = await connection.query(
            "SELECT * FROM `pond_methods`"
        );
        return NextResponse.json(
            { results: results.map(result => result.method) },
            {
                status: 200,
            },
        );
    } catch (e: any) {
        return NextResponse.json(
            { message: "Something went wrong while getting the pond methods" },
            {
                status: 500,
            },
        );
    }
}