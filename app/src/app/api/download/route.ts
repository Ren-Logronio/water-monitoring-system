import getMySQLConnection from "@/db/mysql";
import { NextRequest, NextResponse } from "next/server";


export async function GET(request: NextRequest) {
    try {
        const parameter = request.nextUrl.searchParams.get('parameter');
        const pond_id = request.nextUrl.searchParams.get('pond_id');
        const format = request.nextUrl.searchParams.get('format');
        const connection = await getMySQLConnection();
        const headers: any = {};

        const [results, fields] = await connection.query(
            "SELECT  `name` AS `parameter`,`value`, `recorded_at`, `modified_at`, `isRecordedBySensor` FROM `view_pond_parameter_readings` WHERE `pond_id` = ? AND `name` = ?",
            [pond_id, parameter]
        );

        if (format === "csv") {
            headers['Content-Type'] = 'text/csv';
            headers['Content-Disposition'] = 'attachment;filename=example.csv';

            return NextResponse
        }

        if (format === "pdf") {
            headers['Content-Type'] = 'application/pdf';
            headers['Content-Disposition'] = 'attachment;filename=example.pdf';

            return NextResponse.json(
                { results, fields, format },
                {
                    status: 200,
                    headers
                },
            );
        };

        if (format === "spreadsheet") {
            headers['Content-Type'] = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
            headers['Content-Disposition'] = 'attachment;filename=example.xlsx';

            return NextResponse.
        }

        throw new Error("Invalid format");
    } catch (e) {
        return NextResponse.json(
            { message: "Something went wrong while getting the readings info" },
            {
                status: 500,
            },
        );
    }
}