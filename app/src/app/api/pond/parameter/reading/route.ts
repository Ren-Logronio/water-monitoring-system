import getMySQLConnection from "@/db/mysql";
import { NextRequest, NextResponse } from "next/server";


export async function GET(request: NextRequest) {
    try {
        const pond_id = request.nextUrl.searchParams.get('pond_id');
        const parameter = request.nextUrl.searchParams.get('parameter');
        const connection = await getMySQLConnection();
        const [res, row] = await connection.query(
            "SELECT * FROM `parameter_list` WHERE `name` = ?",
            [parameter]
        );
        const [results, rows]: [results: any[], rows: any[]] = await connection.query(
            "SELECT * FROM `view_pond_parameter_readings` WHERE `pond_id` = ? AND `parameter` = ?",
            [pond_id, res[0].parameter]
        );
        return NextResponse.json(
            { results },
            {
                status: 200,
            },
        );
    } catch (e) {
        console.log(e);
        return NextResponse.json(
            { message: "Something went wrong while getting the readings info" },
            {
                status: 500,
            },
        );
    }
}

export async function POST(request: NextRequest) {
    try {
        const { pond_id, parameter, value, date } = await request.json();
        const connection = await getMySQLConnection();
        const [results, rows]: [results: any[], rows: any[]] = await connection.query(
            "INSERT INTO `readings` (`parameter_id`, `value`, `recorded_at`, `isRecordedBySensor`) VALUES ((SELECT `parameter_id` FROM `view_pond_parameters` WHERE `pond_id` = ? AND `name` = ? LIMIT 1), ?, ?, 0)",
            [pond_id, parameter, value, date]
        );
        return NextResponse.json(
            { results },
            {
                status: 200,
            },
        );
    } catch (e) {
        return NextResponse.json(
            { message: "Something went wrong while adding the readings info" },
            {
                status: 500,
            },
        );
    }
}