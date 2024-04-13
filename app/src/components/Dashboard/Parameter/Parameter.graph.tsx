'use client';

import { FC } from "react";
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer, ReferenceLine } from 'recharts';
import { format } from "date-fns";


// define interface for the props
interface Props {
    readings: any[];
    parameter: any;
    hover: boolean;
}

const ParameterGraph: FC<Props> = ({ readings, parameter, hover }) => {
    // until wala pa na-implement ang pag-fetch sa threshold values sa backend
    const tempThreshold: number = 33;

    // format readings to be used in the graph
    const data = readings.map((reading) => {
        const init: any = {
            date: format(reading.recorded_at, "MMM dd"),
        }
        init[parameter.name] = reading.value.toString();
        return init
    });


    return (
        <ResponsiveContainer width="100%" height="100%" className="p-3">
            <LineChart
                data={data}
                margin={{ top: 5, right: 30, left: 0, bottom: 5 }}
                className={`transition-all ${!hover && 'blur-[0.6px]'}`}
            >
                <CartesianGrid strokeDasharray="1 1" />
                <XAxis dataKey="date" color="#aaaaaa" />
                <YAxis dataKey={parameter.name} color="#aaaaaa" />
                <Tooltip />
                <Line type="monotone" dataKey={parameter.name} stroke="#8884d8" activeDot={{ r: 5 }} />

                {/* Add ReferenceLine for threshold */}
                <ReferenceLine y={tempThreshold} stroke="red" strokeDasharray="3 3" />
            </LineChart>
        </ResponsiveContainer >

    );
};

export default ParameterGraph;