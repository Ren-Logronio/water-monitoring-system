import { NextRequest, NextResponse } from "next/server";
import getMySQLConnection from "@/db/mysql";
import axios from "axios";
import { ResultSetHeader, RowDataPacket } from "mysql2";
import moment from "moment";
import { hardcodedThresholds } from "@/utils/HardcodedThresholds";
import { calculateWQI, classifyWQI } from "@/utils/SimpleFuzzyLogicWaterQuality";

export async function POST(request: NextRequest) {
    try {
        const { device_id, recorded_at: nullable_recorded_at, ...parameters } = await request.json();
        const recorded_at = nullable_recorded_at || moment().format();
        const thresholds: any = hardcodedThresholds;
        if (!device_id) return NextResponse.json({ message: "missing device id" }, { status: 400 });
        const connection = await getMySQLConnection();
        console.log("GEtting device");
        const [results, rows]: [results: any[], rows: any[]] = await connection.query(
            "SELECT * FROM `devices` WHERE `device_id` = ?",
            [device_id]
        );
        if (results.length <= 0) {
            console.log("DEVICE: Init");
            connection.query("INSERT INTO `devices` (`device_id`, `status`) VALUES (?, ?)", [device_id, "IDLE"]);
            return NextResponse.json({ message: "device not found, creating new entry" }, { status: 200 });
        }
        if (results[0].status === "IDLE") {
            console.log("DEVICE: device is idle");
            return NextResponse.json({ message: "no pond assignment, saving to logs" }, { status: 200 });
        }

        await connection.query(
            "UPDATE `devices` SET `last_established_connection` = ? WHERE `device_id` = ?",
            [moment().format(), device_id]
        )

        console.log("Getting Ponds");

        const [ponds]: any = await connection.query("SELECT * FROM `ponds` WHERE `device_id` = ?", [device_id]);
        if (!ponds || !ponds.length) {
            console.log("POND: not found");
            return NextResponse.json({ message: "no pond found" }, { status: 200 });
        };
        const pondId = ponds[0].pond_id;

        // console.log("Getting parameters");
        const [pondParameters]: [results: any[], rows: any[]] = await connection.query(
            "SELECT * FROM `view_pond_parameters` WHERE `pond_id` = ?",
            [pondId]
        );

        const [waterQualityNotifications]: any = await connection.query(
            "SELECT * FROM `pond_water_quality_notifications` WHERE `pond_id` = ? AND `is_resolved` = FALSE LIMIT 1", [pondId]
        );

        // const targetRecordedAt = moment(recorded_at).subtract(1, "hour").format('YYYY-MM-DD HH:mm:ss');

        // const [readings]: [results: any[], rows: any[]] = await connection.query(
        //     "SELECT * FROM `view_pond_readings` WHERE `pond_id` = ? AND `recorded_at` > ?",
        //     [pondId, targetRecordedAt]
        // );

        // console.log("READINGS", readings);

        // readings.push({
        //     temperature: Number(parameters.TMP),
        //     tds: Number(parameters.TDS),
        //     ammonia: Number(parameters.AMN),
        //     ph: Number(parameters.PH),
        //     recorded_at: moment(recorded_at).format(),
        // })

        const temperatureValue = parameters["TMP"];
        const tdsValue = parameters["TDS"];
        const ammoniaValue = parameters["AMN"];
        const phValue = parameters["PH"];

        const wqi = calculateWQI({ ph: phValue, tds: tdsValue, ammonia: ammoniaValue, temperature: temperatureValue });
        console.log("WQI AFTER DEVICE INSERT", wqi);
        const classification = classifyWQI(wqi);

        // const [thresholds]: any = await connection.query("SELECT * FROM `parameter_thresholds`");
        pondParameters.forEach(async (param: any) => {
            // console.log("Inserting:", param, parameters[param.parameter]);
            const [readingsResultHeader] = await connection.query(
                "INSERT INTO `readings` (`parameter_id`, `value`, recorded_at) VALUES (?, ?, ?)",
                [
                    param.parameter_id,
                    Number(parameters[param.parameter]),
                    moment(recorded_at).format(),
                ]
            );
        });

        console.log("NOTIFICATIONS", waterQualityNotifications);
        console.log("AVERAGES", temperatureValue, tdsValue, ammoniaValue, phValue);

        if ((temperatureValue || tdsValue || ammoniaValue || phValue) && (waterQualityNotifications && waterQualityNotifications.length <= 0)) {
            if (wqi < 0.45) {
                await connection.query(
                    "INSERT INTO `pond_water_quality_notifications` (`water_quality`, `pond_id`, `date_issued`) VALUES (?, ?, ?)",
                    [classification, pondId, moment(recorded_at).format()]
                )
            }
        } else if ((temperatureValue || tdsValue || ammoniaValue || phValue) && (waterQualityNotifications && waterQualityNotifications.length > 0)) {
            if (wqi > 0.55) {
                await connection.query(
                    "UPDATE `pond_water_quality_notifications` SET `date_resolved` = ?, is_resolved = TRUE WHERE `notification_id` = ?",
                    [moment().format(), waterQualityNotifications[0].notification_id]
                )
            } else {
                await connection.query(
                    "UPDATE `pond_water_quality_notifications` SET `water_quality` = ? WHERE `notification_id` = ?",
                    [classification, waterQualityNotifications[0].notification_id]
                )
            }
        }

        return NextResponse.json({ message: "responded" }, { status: 200 });
    } catch (error: any) {
        return NextResponse.json({ message: error.message }, { status: 500 })
    }
}