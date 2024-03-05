import getMySQLConnection from "@/db/mysql";
import { NextApiRequest } from "next";
import { NextRequest, NextResponse } from "next/server";

export async function GET(request: NextRequest) {
    try {
        const device_id = request.nextUrl.searchParams.get('device_id');
        const connection = await getMySQLConnection();
        const [results, rows]: [results: any[], rows: any[]] = await connection.query(
            "SELECT * FROM `ponds` WHERE `device_id` = ? AND `status` = 'INACTIVE'",
            [device_id]
        );
        console.log(results);
        return NextResponse.json(
            { results },
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