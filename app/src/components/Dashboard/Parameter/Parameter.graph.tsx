'use client';

import { FC, useEffect, useMemo } from "react";
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer, ReferenceLine, ReferenceArea } from 'recharts';
import { format } from "date-fns";
import moment from "moment";


// define interface for the props
interface Props {
    readings: any[];
    parameter: any;
    hover: boolean;
    thresholds?: any[];
    aggregation?: "minutes" | "hour" | "day" | "week" | "month";
}

const ParameterGraph: FC<Props> = ({ readings, parameter, hover, thresholds, aggregation = "minutes" }) => {
    const peakReading = useMemo(() => {
        return readings.reduce((prev, current) => (prev.value > current.value) ? prev : current);
    }, [readings]);
    const throughReading = useMemo(() => {
        return readings.reduce((prev, current) => (prev.value < current.value) ? prev : current);
    }, [readings]);
    const minDomain = useMemo(() => {
        return (thresholds && thresholds.length && thresholds.find(threshold => threshold.type === "LT") && thresholds.find(threshold => threshold.type === "LT").target - 5) || 0;
    }, [thresholds]);
    const maxDomain = useMemo(() => {
        return (thresholds && thresholds.length && thresholds.find(threshold => threshold.type === "GT") && thresholds.find(threshold => threshold.type === "GT").target + 5) || 50
    }, [thresholds])

    useEffect(() => {
        console.log("PEAK", peakReading);
        console.log("THROUGH", throughReading);
    }, [peakReading, throughReading]);

    const aggReadings = useMemo(() => {
        // round of the time to the nearest aggregation
        const nearestAggregation = readings.map((reading) => ({ ...reading, recorded_at: moment(reading.recorded_at).startOf(aggregation).toDate() }));
        // return unique recorded at
        const uniqueTimes = nearestAggregation.filter((reading, index, self) => self.findIndex((r) => moment(r.recorded_at).isSame(reading.recorded_at)) === index);
        // for each uniqueTimes get the average value from nearestAggregation
        const aggregatedReadings = uniqueTimes.map((time) => {
            const values = nearestAggregation.filter((reading) => moment(reading.recorded_at).isSame(time.recorded_at));
            const average = Math.round((values.reduce((acc, curr) => acc + curr.value, 0) / values.length) * 100) / 100;
            return { recorded_at: time.recorded_at, value: average };
        });
        return aggregatedReadings;
    }, [aggregation, readings]);

    const getProperDateTimeFormat = () => {
        switch (aggregation) {
            case "minutes":
                return "hh:mm a";
            case "hour":
                return "MMM DD - h a";
            case "day":
                return "MMM DD, yyyy";
            case "week":
                return "MMM DD, yyyy";
            case "month":
                return "MMM DD, yyyy";
            default:
                return "MMM DD, yyyy - h:mm a";
        }
    }

    // format readings to be used in the graph
    // const data = useMemo(() => {
    //     const oldestTimestamp = moment(readings[0].recorded_at);
    //     const latestTimestamp = moment(readings[readings.length - 1].recorded_at);
    //     let cursorTimestamp = oldestTimestamp;
    //     const finalReadings: any = [];
    //     let limit = 0;
    //     while (cursorTimestamp.isBefore(moment().startOf(aggregation)) || limit <= 5) {
    //         const reading = aggReadings.find(reading => moment(reading.recorded_at).isSame(moment(cursorTimestamp)));
    //         if (!reading) {
    //             finalReadings.push({ recorded_at: moment(cursorTimestamp).format(getProperDateTimeFormat()), [parameter.name]: null });
    //             continue;
    //         }
    //         finalReadings.push({ recorded_at: moment(cursorTimestamp).format(getProperDateTimeFormat()), [parameter.name]: reading.value.toString()});
    //         cursorTimestamp = cursorTimestamp.add(1, aggregation).startOf(aggregation);
    //         limit++;
    //     };
    //     return finalReadings;
    // }, [aggReadings]);

    // useEffect(() => {
    //     if (!aggReadings?.length) return;
    //     const oldestTimestamp = moment(aggReadings[0].recorded_at);
    //     const latestTimestamp = moment(aggReadings[aggReadings.length - 1].recorded_at).add(1, aggregation).startOf(aggregation);
    //     const timestamps = [];
    //     while (oldestTimestamp.isBefore(latestTimestamp)) {
    //         timestamps.push(oldestTimestamp.format());
    //         oldestTimestamp.add(1, aggregation).startOf(aggregation);
    //     }
    //     console.log("timestamps", timestamps, "=>", timestamps.map((timestamp) => {
    //         return { ...aggReadings.find((reading) => moment(reading.recorded_at).isSame(moment(timestamp), aggregation)), compared_timestamp: timestamp }
    //     }).map(reading => reading?.value ? {date: moment(reading.compared_timestamp).format(getProperDateTimeFormat()), [parameter.name]: reading?.value?.toString()} : {
    //         date: moment(reading.compared_timestamp).format(getProperDateTimeFormat()), [parameter.name]: null
    //     }));
    // }, [aggReadings])

    const data = useMemo(() => {
        if (!aggReadings?.length) return;
        const oldestTimestamp = moment(aggReadings[0].recorded_at);
        const latestTimestamp = moment(aggReadings[aggReadings.length - 1].recorded_at).add(1, aggregation).startOf(aggregation);
        const timestamps = [];
        while (oldestTimestamp.isBefore(latestTimestamp)) {
            timestamps.push(oldestTimestamp.format());
            oldestTimestamp.add(1, aggregation).startOf(aggregation);
        }
        return timestamps.map((timestamp) => {
            return { ...aggReadings.find((reading) => moment(reading.recorded_at).isSame(moment(timestamp), aggregation)), compared_timestamp: timestamp }
        }).map(reading => reading?.value ? {date: moment(reading.compared_timestamp).format(getProperDateTimeFormat()), [parameter.name]: reading?.value?.toString()} : {
            date: moment(reading.compared_timestamp).format(getProperDateTimeFormat()), [parameter.name]: null
        });
    }, [aggReadings]);

    // const data = useMemo(() => aggReadings.map((reading) => {
    //     const init: any = {
    //         date: format(reading.recorded_at, getProperDateTimeFormat()),
    //     }
    //     init[parameter.name] = reading.value.toString();
    //     return init
    // }), [aggReadings]);

    return (
        <ResponsiveContainer width="100%" height="100%" className="p-3">
            <LineChart
                data={data}
                margin={{ top: 5, right: 30, left: 0, bottom: 5 }}
                className={`transition-all ${!hover && 'blur-[0.6px]'}`}
            >
                <CartesianGrid strokeDasharray="1 1" />
                <XAxis dataKey="date" color="#aaaaaa" />
                <YAxis dataKey={parameter.name} color="#aaaaaa" domain={[minDomain, maxDomain]} />
                <Tooltip />
                <Line type="monotone" dataKey={parameter.name} stroke="#205083" strokeLinecap="round" activeDot={{ r: 5 }} />
                <ReferenceArea y1={undefined} />
                {
                    thresholds?.map((threshold: any) => {
                        return <>
                            <ReferenceLine
                                y={Number(threshold.target)}
                                fontSize={1}
                                label={threshold.action === "ALRT" ? "Alert" : threshold.action === "WARN" ? "Warning" : undefined}
                                stroke={threshold.action === "ALRT" ? "#ff0000" : threshold.action === "WARN" ? "#e8a72e" : "#293447"}
                                strokeDasharray="3 3" />
                            <ReferenceArea
                                y1={threshold.type === "GT" ? Number(threshold.target) : undefined}
                                y2={threshold.type === "LT" ? Number(threshold.target) : undefined}
                                fill={`${threshold.action === "ALRT" ? "#ff0000" : threshold.action === "WARN" ? "#e8a72e" : "#293447"}`}
                                opacity={0.25} />
                        </>
                    })
                }
                {/* Add ReferenceLine for threshold
                <ReferenceLine y={tempThreshold} stroke="red" strokeDasharray="3 3" /> */}
            </LineChart>
        </ResponsiveContainer >
    );
};

export default ParameterGraph;