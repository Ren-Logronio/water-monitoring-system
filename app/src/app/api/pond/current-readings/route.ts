import getMySQLConnection from "@/db/mysql";
import { calculateWQI, classifyWQI } from "@/utils/SimpleFuzzyLogicWaterQuality";
import { NextRequest, NextResponse } from "next/server";

export async function GET(request: NextRequest) {
    const pond_id = request.nextUrl.searchParams.get("pond_id");
    const connection = await getMySQLConnection();
    const [pond_readings]: any = await connection.query(
        "SELECT * FROM `view_pond_readings` WHERE `pond_id` = ? ORDER BY `recorded_at` DESC",
        [pond_id]
    );
    try {
        return NextResponse.json({
            results: pond_readings.map((reading: any) => ({...reading, 
                wqi: calculateWQI({temperature: reading.temperature, ph: reading.ph, tds: reading.tds, ammonia: reading.ammonia,}),
                classification: classifyWQI(calculateWQI({temperature: reading.temperature, ph: reading.ph, tds: reading.tds, ammonia: reading.ammonia,})),
                timestamp: reading.recorded_at}
            )),
        }, {
            status: 200,
        });
    } catch (error: any) {
        return NextResponse.json({
            message: error.message || "An unknown error occured",
        }, {
            status: 500,
        })
    }
}