import getMySQLConnection from "@/db/mysql";
import { NextRequest, NextResponse } from "next/server";


export async function GET(request: NextRequest) {
    try {
        const pond_id = request.nextUrl.searchParams.get('pond_id');
        const parameter = request.nextUrl.searchParams.get('parameter');
        const connection = await getMySQLConnection();
        const [res, row]: any = await connection.query(
            "SELECT * FROM `parameter_list` WHERE `name` = ? OR `parameter` = ?",
            [parameter, parameter]
        );
        const [results, rows]: [results: any[], rows: any[]] = await connection.query(
            "SELECT * FROM `view_pond_parameter_readings` WHERE `pond_id` = ? AND `parameter` = ?",
            [pond_id, res[0].parameter]
        );
        console.log("RESULTS:", results);
        return NextResponse.json(
            { results },
            {
                status: 200,
            },
        );
    } catch (e: any) {
        console.log(e);
        return NextResponse.json(
            {
                message: e.message || "Something went wrong while getting the readings info"
            },
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
        const [results, rows]: any = await connection.query(
            "INSERT INTO `readings` (`parameter_id`, `value`, `recorded_at`, `isRecordedBySensor`) VALUES ((SELECT `parameter_id` FROM `view_pond_parameters` WHERE `pond_id` = ? AND ? IN (`name`, `parameter`) LIMIT 1), ?, ?, 0)",
            [pond_id, parameter, value, date]
        );
        const readingId = results.insertId;
        const [farmers]: any = await connection.query(
            "SELECT `user_id` FROM `view_farmer_ponds` WHERE `pond_id` = ?",
            [pond_id]
        );
        // const [thresholds]: any = await connection.query(
        //     "SELECT * FROM `parameter_thresholds` LEFT JOIN parameter_list ON parameter_list.parameter = parameter_thresholds.parameter WHERE ? IN (parameter_list.name, parameter_list.parameter)",
        //     [parameter],
        // );
        // thresholds.forEach((threshold: any) => {
        //     switch (threshold.type) {
        //         case "LT":
        //             if (Number(value) < (threshold.target + threshold.error)) {
        //                 console.log("Threshold LT breached:", parameter, value);
        //                 farmers.forEach(async (farmer: any) => {
        //                     await connection.query("INSERT INTO `reading_notifications` (`user_id`, `threshold_id`, `reading_id`) VALUES (?, ?, ?)", [farmer.user_id, threshold.threshold_id, readingId]);
        //                 });
        //             }
        //             break;
        //         case "GT":
        //             if (Number(value) > (threshold.target - threshold.error)) {
        //                 console.log("Threshold GT breached:", parameter, value);
        //                 farmers.forEach(async (farmer: any) => {
        //                     await connection.query("INSERT INTO `reading_notifications` (`user_id`, `threshold_id`, `reading_id`) VALUES (?, ?, ?)", [farmer.user_id, threshold.threshold_id, readingId]);
        //                 });
        //             }
        //             break;
        //         case "EQ":
        //             if (Number(value) > (threshold.target - threshold.error) && Number(value) < (threshold.value + threshold.error)) {
        //                 console.log("Threshold EQ breached:", parameter, value);
        //                 farmers.forEach(async (farmer: any) => {
        //                     await connection.query("INSERT INTO `reading_notifications` (`user_id`, `threshold_id`, `reading_id`) VALUES (?, ?, ?)", [farmer.user_id, threshold.threshold_id, readingId]);
        //                 });
        //             }
        //             break;
        //         default:
        //             break;
        //     }
        // });
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