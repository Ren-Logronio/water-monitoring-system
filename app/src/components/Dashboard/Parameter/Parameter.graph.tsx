'use client';

import { FC, useEffect } from "react";
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer, ReferenceLine, ReferenceArea } from 'recharts';
import { format } from "date-fns";


// define interface for the props
interface Props {
    readings: any[];
    parameter: any;
    hover: boolean;
    thresholds?: any[];
}

const ParameterGraph: FC<Props> = ({ readings, parameter, hover, thresholds }) => {

    // format readings to be used in the graph
    const data = readings.map((reading) => {
        const init: any = {
            date: format(reading.recorded_at, "MMM dd"),
        }
        init[parameter.name] = reading.value.toString();
        return init
    });

    useEffect(() => {
        console.log("thresholdsxx", thresholds);
    }, [thresholds]);

    return (
        <ResponsiveContainer width="100%" height="100%" className="p-3">
            <LineChart
                data={data}
                margin={{ top: 5, right: 30, left: 0, bottom: 5 }}
                className={`transition-all ${!hover && 'blur-[0.6px]'}`}
            >
                <CartesianGrid strokeDasharray="1 1" />
                <XAxis dataKey="date" color="#aaaaaa" />
                <YAxis dataKey={parameter.name} color="#aaaaaa"  domain={[ 
                    (thresholds && thresholds.length && thresholds.find(threshold => threshold.type === "LT") && thresholds.find(threshold => threshold.type === "LT").target - 5) || 0,
                    (thresholds && thresholds.length && thresholds.find(threshold => threshold.type === "GT") && thresholds.find(threshold => threshold.type === "GT").target + 5) || 50
                    ]}/>
                <Tooltip />
                <Line type="monotone" dataKey={parameter.name} stroke="#8884d8" activeDot={{ r: 5 }} />
                <ReferenceArea y1={undefined} />
                {
                    thresholds?.map((threshold: any) => {
                        return <ReferenceArea 
                        label="threshold"
                        y1={threshold.type === "GT" ? Number(threshold.target) : undefined} 
                        y2={threshold.type === "LT" ? Number(threshold.target) : undefined} 
                        fill={`${threshold.action === "ALRT" ? "#ff0000" : threshold.action === "WARN" ? "#e8a72e" : "#293447"}`} 
                        fillOpacity={0.2} />
                    })
                }
                {/* Add ReferenceLine for threshold
                <ReferenceLine y={tempThreshold} stroke="red" strokeDasharray="3 3" /> */}
            </LineChart>
        </ResponsiveContainer >
    );
};

export default ParameterGraph;