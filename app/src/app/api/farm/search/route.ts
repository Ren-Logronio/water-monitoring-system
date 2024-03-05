import getMySQLConnection from "@/db/mysql";
import { NextRequest, NextResponse } from "next/server";


export async function GET(request: NextRequest) {
    try {
        const query = request.nextUrl.searchParams.get('q');
        const connection = await getMySQLConnection();
        const [results, rows]: [results: any[], rows: any[]] = await connection.query(
            "SELECT * FROM `farms` WHERE `name` LIKE ? OR `address_street` LIKE ? OR `address_city` LIKE ? OR `address_province` LIKE ?",
            [`%${query}%`, `%${query}%`, `%${query}%`, `%${query}%`]
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