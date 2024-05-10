import getMySQLConnection from "@/db/mysql";
import axios from "axios";
import moment from "moment";
import { NextRequest, NextResponse } from "next/server";
import xlsxPopulate from "xlsx-populate";
import path from 'path';
// import ExcelJS from "exceljs";

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
        const [farmPond]: any = await connection.query("SELECT `ponds`.`pond_id`, `ponds`.`name` AS `pond_name`, `farms`.`name` AS `farm_name`, `farms`.`address_street`, `farms`.`address_city`, `farms`.`address_city`, `farms`.`address_province` FROM `ponds` LEFT JOIN `farms` ON `ponds`.`farm_id` = `farms`.`farm_id` WHERE `ponds`.`pond_id` = ?", [pond_id]);
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
                csv += `${index},${moment(reading.recorded_at).format("yyyy-MM-ddd")},${moment(reading.recorded_at).format("h:mm a")},${reading.parameter},${reading.value}\n`;
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
        console.log("GENERATING SPREADSHEET");
        const spreadsheet = await xlsxPopulate.fromFileAsync(path.join(process.cwd(), 'public', 'templates', 'template-parameter-logs.xlsx'));

        const aggReadings = pondParameterReadings.map(
            (readings: any) => ({
                ...readings, 
                recorded_at: moment(readings.recorded_at).startOf("hour").format()
            })
        );
        const uniqueTimes = aggReadings.filter(
            (reading: any, index: number, self: any[]) => self.findIndex((r) => moment(r.recorded_at).isSame(reading.recorded_at)) === index
        );
        const aggregatedReadings = uniqueTimes.map(
            (time: any) => {
                const values = aggReadings.filter((reading: any) => moment(reading.recorded_at).isSame(time.recorded_at));
                const average = Math.round((values.reduce((acc: number, curr: any) => acc + curr.value, 0) / values.length) * 100) / 100;
                return { recorded_at: time.recorded_at, value: average };
            }
        );

        const roundToSecondDecimal = (value: number) => Math.round(value * 100) / 100;

        const meanRateOfChange = roundToSecondDecimal(aggregatedReadings.reduce((acc: number, curr: any, index: number, self: any[]) => {
            if (index === 0) return acc;
            const previous = self[index - 1];
            const rateOfChange = Math.abs((curr.value - previous.value) / (moment(curr.recorded_at).diff(moment(previous.recorded_at), 'hours')));
            return acc + rateOfChange;
        }, 0) / aggregatedReadings.length);
        const mean = roundToSecondDecimal(aggregatedReadings.reduce((acc: number, curr: any) => acc + curr.value, 0) / aggregatedReadings.length);
        const standardDeviation = roundToSecondDecimal(Math.sqrt(aggregatedReadings.reduce((acc: number, curr: any) => acc + Math.pow(curr.value - mean, 2), 0) / aggregatedReadings.length));
        const max = roundToSecondDecimal(Math.max(...aggregatedReadings.map((reading: any) => reading.value)));
        const min = roundToSecondDecimal(Math.min(...aggregatedReadings.map((reading: any) => reading.value)));

        spreadsheet.sheet(0).cell('A1').value(farmPond[0].farm_name);
        spreadsheet.sheet(0).cell('A2').value(`${[farmPond[0].address_street, farmPond[0].address_city, farmPond[0].address_province].join(", ") || "Mindanao State University General Santos"}`);
        spreadsheet.sheet(0).cell('A4').value(`${farmPond[0].pond_name} Water ${pondParameterReadings[0].name} Logs`);

        let dateRangeText = [];

        if (moment(from).isSame(moment.unix(0))) {
            dateRangeText.push("Until");
        } else {
            dateRangeText.push(`From ${moment(from).format("MMM DD, yyyy")} to`);
        }

        if (moment(to).isSame(moment())) {
            dateRangeText.push("Now (" + moment(from).format("MMM DD, yyyy") + ")");
        } else {
            dateRangeText.push(`${moment(to).format("MMM DD, yyyy")}`);
        }

        spreadsheet.sheet(0).cell('A6').value(`Date Range: ${dateRangeText.join(" ")}`);
        spreadsheet.sheet(0).cell('C6').value(`Date: ${moment().format("MMM DD, yyyy, h:mm a")}`);

        spreadsheet.sheet(0).cell('B8').value(`${min} - ${max} ${pondParameterReadings[0].unit}`);
        spreadsheet.sheet(0).cell('B9').value(mean);
        spreadsheet.sheet(0).cell('B10').value(standardDeviation);
        spreadsheet.sheet(0).cell('B11').value(`${meanRateOfChange} per hour`);

        spreadsheet.sheet(0).cell("C13").value(pondParameterReadings[0].name);

        pondParameterReadings.forEach((reading: any, index: number) => {
            const row = index + 14;
            spreadsheet.sheet(0).cell(`A${row}`).value(moment(reading.recorded_at).format("MMM DD, yyyy"));
            spreadsheet.sheet(0).cell(`B${row}`).value(moment(reading.recorded_at).format("h:mm a"));
            spreadsheet.sheet(0).cell(`C${row}`).value(`${reading.value} ${reading.unit}`);
        });

        const buffer = await spreadsheet.outputAsync();

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
    } catch (err: any) {
        return NextResponse.json(
            { message: err.message || "Something went wrong while getting the notification count" },
            {
                status: 500,
            },
        );
    }
}