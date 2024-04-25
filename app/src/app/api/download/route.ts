import getMySQLConnection from "@/db/mysql";
import { NextRequest, NextResponse } from "next/server";

export async function GET(request: NextRequest){
    try {
        const format = request.nextUrl.searchParams.get('format');
        const pond_id = request.nextUrl.searchParams.get('pond_id');
        const parameter = request.nextUrl.searchParams.get('parameter');
        const connection = await getMySQLConnection();
        const [pondParameterReadings]: any = await connection.query(
            "SELECT * FROM `view_pond_parameter_readings` WHERE `pond_id` = ? AND ? IN (`parameter`, `name`)",
            [pond_id, parameter]
        );
        if (pondParameterReadings.length <= 0) {
            return NextResponse.json(
                { message: "Parameter not found" },
                {
                    status: 400,
                },
            );
        }
        const readings = await connection.query(
            "SELECT * FROM `readings` WHERE `parameter_id` = ? ORDER BY `created_at` DESC",
            [pondParameterReadings[0].parameter_id]
        );
        return NextResponse.json(
            { message: "Responded" },
            {
                status: 200,
            },
        );
    } catch (err: any) {
        return NextResponse.json(
            { message: err.message || "Something went wrong while getting the notification count" },
            {
                status: 500,
            },
        );
    }
}