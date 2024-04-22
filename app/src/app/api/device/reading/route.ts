import { NextRequest, NextResponse } from "next/server";
import getMySQLConnection from "@/db/mysql";
import axios from "axios";

export async function POST(request: NextRequest) {
    try {
        const { device_id, ...parameters } = await request.json();
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
        let pondId;
        {
            console.log("Getting Ponds");
            const [results, rows] = await connection.query("SELECT * FROM `ponds` WHERE `device_id` = ?", [device_id]);
            pondId = results[0].pond_id;
        }
        {
            console.log("Getting parameters");
            const [results, rows]: [results: any[], rows: any[]] = await connection.query(
                "SELECT * FROM `view_pond_parameters` WHERE `pond_id` = ?",
                [pondId]
            );
            results.forEach(async (param: any) => {
                const [results, rows] = await connection.query("SELECT * FROM `parameter_thresholds` WHERE `parameter_id` = ?", [param.parameter_id]);
                console.log("Checking param thresholds")
                results.forEach((threshold: any) => {
                    if (threshold.type === "GT") {
                        if (Number(parameters[param.parameter]) > threshold.target) {
                            console.log("Parameter is exceeding limits")
                        }
                    } else if (threshold.type === "LT") {
                        if (Number(parameters[param.parameter] < threshold.target)) {
                            console.log("Parameter is under")
                        }
                    } else if (threshold.type === "EQ") {
                        if (Number(parameters[param.parameter]) >= (threshold.target - threshold.error) && Number(parameters[param.parameter]) <= (threshold.target + threshold.error)) {
                            console.log("Parameter is reaching threshold")
                        }
                    }
                    console.log("Parameter value is nominal");
                });
                console.log("Inserting:", param, parameters[param.parameter]);
                connection.query("INSERT INTO `readings` (`parameter_id`, `value`) VALUES (?, ?)", [param.parameter_id, Number(parameters[param.parameter])]);
            });
        }
        return NextResponse.json({ message: "responded" }, { status: 200 });
    } catch (error: any) {
        return NextResponse.json({ message: error.message }, { status: 500 })
    }
}