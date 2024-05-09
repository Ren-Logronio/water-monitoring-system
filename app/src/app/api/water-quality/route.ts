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
    const uniqueTimes = aggReadings.filter((reading: any, index: number, self: any[]) => self.findIndex((r) => moment(r.recorded_at).isSame(reading.recorded_at)) === index);
    const aggregatedReadings = uniqueTimes.map((time: any) => {
        const values = aggReadings.filter((reading: any) => moment(reading.recorded_at).isSame(time.recorded_at));
        const average = Math.round((values.reduce((acc: number, curr: any) => acc + curr.value, 0) / values.length) * 100) / 100;
        return { recorded_at: time.recorded_at, value: average };
    });
    return aggregatedReadings;
}

export async function GET(request: NextRequest) {
    try {
        const pond_id = request.nextUrl.searchParams.get("pond_id");
        const connection = await getMySQLConnection();
        const [readings]: any = await connection.query(
            `SELECT * FROM view_pond_parameter_readings WHERE pond_id = ?`, 
            [pond_id]
        );
        const ammoniaReadings = readings.filter((reading: any) => reading.parameter === "AMN");
        const phReadings = readings.filter((reading: any) => reading.parameter === "PH");
        const temperatureReadings = readings.filter((reading: any) => reading.parameter === "TMP");
        const tdsReadings = readings.filter((reading: any) => reading.parameter === "TDS");
        const ammoniaAggregated = aggregateReadings(ammoniaReadings);
        const phAggregated = aggregateReadings(phReadings);
        const temperatureAggregated = aggregateReadings(temperatureReadings);
        const tdsAggregated = aggregateReadings(tdsReadings);
        const presentTimestamp: any = [];
        [ammoniaAggregated, phAggregated, temperatureAggregated, tdsAggregated].forEach((readings: any) => {
            readings.forEach((reading: any) => {
                if(presentTimestamp.find((timestamp: any) => moment(timestamp).isSame(reading.recorded_at))) {
                    return;
                }
                presentTimestamp.push(reading.recorded_at);
            });
        });
        const combinedReadingsByTimestamp = presentTimestamp.map((timestamp: any) => {
            const ammonia = ammoniaAggregated.find((reading: any) => moment(reading.recorded_at).isSame(timestamp)).value;
            const ph = phAggregated.find((reading: any) => moment(reading.recorded_at).isSame(timestamp)).value;
            const temperature = temperatureAggregated.find((reading: any) => moment(reading.recorded_at).isSame(timestamp)).value;
            const tds = tdsAggregated.find((reading: any) => moment(reading.recorded_at).isSame(timestamp)).value;
            let wqi, classification;
            if (ph && tds && ammonia && temperature) {
                wqi = calculateWQI(ph, tds, ammonia, temperature);
                classification = classifyWQI(wqi);
            } else {
                wqi = null;
                classification = null;
            }
            return { timestamp, ammonia, ph, temperature, tds, wqi, classification };
        });
        return NextResponse.json({results: combinedReadingsByTimestamp}, { status: 200 });
    } catch (error: any) {
        return NextResponse.json({ error: error?.message || "An error occurred" }, { status: 500 });
    }
}