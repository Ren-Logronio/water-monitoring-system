import getMySQLConnection from "@/db/mysql";
import moment from "moment";
import { NextRequest, NextResponse } from "next/server";
import ExcelJS from "exceljs";

export async function GET(request: NextRequest){
    try {
        const format = request.nextUrl.searchParams.get('format');
        const pond_id = request.nextUrl.searchParams.get('pond_id');
        const parameter = request.nextUrl.searchParams.get('parameter');
        const from = request.nextUrl.searchParams.get('from');
        const to = request.nextUrl.searchParams.get('to');
        const all = request.nextUrl.searchParams.get('all');
        const connection = await getMySQLConnection();
        console.log("FROM AND TO", from, to);
        const [pondParameterReadings]: any = all ? await connection.query(
            "SELECT * FROM `view_pond_parameter_readings` WHERE `pond_id` = ?",
            [pond_id, parameter]
        )
        :
        await connection.query(
            "SELECT * FROM `view_pond_parameter_readings` WHERE `pond_id` = ? AND ? IN (`parameter`, `name`)",
            [pond_id, parameter]
        );
        console.log("FROM TO TEST", moment(from).format(), moment(to).format());
        if (pondParameterReadings.length <= 0) {
            return NextResponse.json(
                { message: "Parameter not found" },
                {
                    status: 400,
                },
            );
        }
        if (format === 'csv') {
            // Generate CSV
            let csv = '#,Date,Time,Parameter,Value\n';
            pondParameterReadings
                .sort((a: any, b: any) => moment(a.recorded_at).diff(b.recorded_at))
                .filter((reading: any) => moment(reading.recorded_at).isBetween(moment(from), moment(to)))
                .forEach((reading: any, index: number) => {
                csv += `${index},${moment(reading.recorded_at).format("yyyy-MM-dd")},${moment(reading.recorded_at).format("hh:mm")},${reading.parameter},${reading.value}\n`;
            });
            const headers = new Headers();
            headers.set('Content-Type', 'text/csv');
            return new NextResponse(
                csv,
                {
                    headers,
                    statusText: 'OK',
                    status: 200,
                },
            );
        }
        if (format === 'spreadsheet') {
            // generate spreadsheet
            const workbook = new ExcelJS.Workbook();
            const worksheet = workbook.addWorksheet('Readings');
            worksheet.columns = [
                { header: 'Date', key: 'created_at', width: 20 },
                { header: 'Time', key: 'recorded_at', width: 20 },
                { header: 'Parameter', key: 'parameter', width: 20 },
                { header: 'Value', key: 'value', width: 20 },
            ];
            pondParameterReadings
                .sort((a: any, b: any) => moment(a.recorded_at).diff(b.recorded_at))
                .forEach((reading: any) => {
                worksheet.addRow({
                    created_at: reading.created_at,
                    recorded_at: reading.recorded_at,
                    parameter: reading.parameter,
                    value: reading.value,
                });
            });
            const buffer = await workbook.xlsx.writeBuffer();

            const headers = new Headers();
            headers.set('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
            headers.set('Content-Disposition', 'attachment; filename=readings.xlsx');
            return new NextResponse(
                buffer,
                {
                    headers,
                    statusText: 'OK',
                    status: 200,
                },
            );
        }
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