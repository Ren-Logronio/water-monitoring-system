import getMySQLConnection from "@/db/mysql";
import { calculateWQI, classifyWQI } from "@/utils/SimpleFuzzyLogicWaterQuality";
import moment from "moment";
import { NextRequest, NextResponse } from "next/server";

export const aggregateReadings = (readings: any, aggregation: any = "hour") => {
    const aggReadings = readings.map(
        (readings: any) => ({
            ...readings, 
            recorded_at: moment(readings.recorded_at).startOf(aggregation).format()
        })
    );
    const uniqueTimes = aggReadings.filter(
        (reading: any, index: number, self: any[]) => self.findIndex((r) => moment(r.recorded_at).isSame(reading.recorded_at)) === index
    );
    const aggregatedReadings = uniqueTimes.map(
        (time: any) => {
            const values = aggReadings.filter((reading: any) => moment(reading.recorded_at).isSame(time.recorded_at));
            const averageTemperature = Math.round((values.reduce((acc: number, curr: any) => acc + curr.temperature, 0) / values.length) * 100) / 100;
            const averagePh = Math.round((values.reduce((acc: number, curr: any) => acc + curr.ph, 0) / values.length) * 100) / 100;
            const averageTds = Math.round((values.reduce((acc: number, curr: any) => acc + curr.tds, 0) / values.length) * 100) / 100;
            const averageAmmonia = Math.round((values.reduce((acc: number, curr: any) => acc + curr.ammonia, 0) / values.length) * 100) / 100;
            return { recorded_at: time.recorded_at, temperature: averageTemperature, ph: averagePh, tds: averageTds, ammonia: averageAmmonia };
        }
    );
    return aggregatedReadings;
}

export async function GET(request: NextRequest) {
    try {
        console.log("WATER QUALITY TEST")
        // get start time
        const before = performance.now();
        const pond_id = request.nextUrl.searchParams.get("pond_id");
        const connection = await getMySQLConnection();
        const [readings]: any = await connection.query(
            `SELECT * FROM view_pond_readings WHERE pond_id = ?`, 
            [pond_id]
        );
        const aggReadings = aggregateReadings(readings);
        const aggReadingsWithWQI = aggReadings.map((reading: any) => {
            if (!reading.ph || !reading.tds || !reading.ammonia || !reading.temperature) {
                return { ...reading, wqi: null, classification: null };
            }
            const wqi = calculateWQI({ ph: reading.ph, tds: reading.tds, ammonia: reading.ammonia, temperature: reading.temperature });
            const classification = classifyWQI(wqi);
            return { ...reading, timestamp: reading.recorded_at, wqi, classification };
        });
        const after = performance.now();
        console.log("Time taken to process request", after - before, "ms");
        return NextResponse.json({results: aggReadingsWithWQI}, { status: 200 });
    } catch (error: any) {
        return NextResponse.json({ error: error?.message || "An error occurred" }, { status: 500 });
    }
}