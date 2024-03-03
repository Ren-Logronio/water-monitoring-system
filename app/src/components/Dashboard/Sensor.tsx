import axios from "axios";
import { useEffect, useState } from "react";
import { NinetyRing } from "react-svg-spinners";
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts';

export default function Sensor({ sensor_id, name, unit }: { sensor_id: number, name: string, unit: string}) {
    const [ readings, setReadings ] = useState<any[]>([]);
    const [ loading, setLoading ] = useState(true);

    useEffect(() => {
        axios.get(`/api/reading?sensor_id=${sensor_id}`).then((response) => {
            if(response.data.results && response.data.results.length > 0) {
                setReadings(response.data.results);
            }
        }).catch((error) => {
            console.error(error);
        }).finally(() => {
            setLoading(false);
        });
    }, [sensor_id]);

    useEffect(() => {
    }, [readings]);

    return (
        <div className="relative flex min-h-[352px] bg-white flex flex-col justify-center items-center">
            {
                loading ? <NinetyRing/>
                : readings.length > 0 ? <></>
                : <p>No readings found</p>
            }
        </div>
    );
}