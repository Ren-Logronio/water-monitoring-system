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
        console.log("Getting Ponds");

        const [ponds]: any = await connection.query("SELECT * FROM `ponds` WHERE `device_id` = ?", [device_id]);
        const pondId = ponds[0].pond_id;

        console.log("Getting parameters");
        const [pondParameters]: [results: any[], rows: any[]] = await connection.query(
            "SELECT * FROM `view_pond_parameters` WHERE `pond_id` = ?",
            [pondId]
        );
        const [thresholds]: any = await connection.query("SELECT * FROM `parameter_thresholds`");
        pondParameters.forEach(async (param: any) => {
            console.log("Inserting:", param, parameters[param.parameter]);
            connection.query("INSERT INTO `readings` (`parameter_id`, `value`) VALUES (?, ?)", [param.parameter_id, Number(parameters[param.parameter])]);

            console.log("Checking param thresholds");
            thresholds
                .filter((threshold: any) => threshold.parameter === param.parameter)
                .forEach((threshold: any) => {
                    switch (threshold.type) {
                        case "LT":
                            if (Number(parameters[param.parameter]) < (threshold.value + threshold.error)) {
                                console.log("Threshold LT breached:", param, parameters[param.parameter]);
                            }
                            break;
                        case "GT":
                            if (Number(parameters[param.parameter]) > (threshold.target - threshold.error)) {
                                console.log("Threshold GT breached:", param, parameters[param.parameter]);
                            }
                            break;
                        case "EQ":
                            if (Number(parameters[param.parameter]) > (threshold.target - threshold.error) && Number(parameters[param.parameter]) < (threshold.value + threshold.error)) {
                                console.log("Threshold EQ breached:", param, parameters[param.parameter]);
                            }
                            break;
                        default:
                            break;
                    }
                });
        });
            
        

        return NextResponse.json({ message: "responded" }, { status: 200 });
    } catch (error: any) {
        return NextResponse.json({ message: error.message }, { status: 500 })
    }
}