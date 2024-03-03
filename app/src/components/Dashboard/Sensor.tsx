import axios from "axios";
import { format } from "date-fns";
import { useEffect, useState } from "react";
import { NinetyRing } from "react-svg-spinners";
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts';

export default function Sensor({ sensor_id, name, unit }: { sensor_id: number, name: string, unit: string}) {
    const [ readings, setReadings ] = useState<any[]>([]);
    const [ hover, setHover ] = useState<boolean>(false);
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

    const handleMouseEnter = () => {
        setHover(true);
    }

    const handleMouseLeave = () => {
        setHover(false);
    }

    return (
        <div onMouseEnter={handleMouseEnter} onMouseLeave={handleMouseLeave} className="relative rounded-[var(--radius)] overflow-hidden flex min-h-[352px] bg-white flex flex-col justify-center items-center">
            {
                loading ? <NinetyRing/>
                : readings.length > 0 ? <>
                <div className={`absolute z-30 size-full flex flex-col justify-end transition-all from-[#90b9e4] to-transparent bg-gradient-to-tr ${ hover ? 'opacity-0 pointer-events-none' : 'opacity-100' }`}>
                    <div className="text-blue-900 mx-8 mb-5">
                        <h1 className="text-[20px] leading-[28px] font-medium">{ name }</h1>
                        <div className="flex flex-row items-center space-x-2">
                            <p className="text-[40px] leading-[32px] m-0 font-semibold">{ readings.sort((a, b) => b.reading_id - a.reading_id)[0].value }</p>
                            <p className="text-[32px] leading-[26px] m-0 font-semibold">{ unit }</p>
                        </div>
                        <p className="text-[14px] font-light m-0 pl-4">Last recorded reading</p>
                    </div>
                </div>
                <div>
                    ewrwerwe
                </div>
                <LineChart
                    width={600}
                    height={300}
                    data={
                        readings.sort((a, b) => a.reading_id - b.reading_id).map((reading) => {
                            const init: any = {
                                date: format(reading.recorded_at, "MMM dd"),
                            }
                            init[name] = reading.value.toString();
                            return init
                        })
                    }
                    margin={{ top: 5, right: 20, left: 20, bottom: 5 }}
                >
                    <CartesianGrid strokeDasharray="1 1" />
                    <XAxis dataKey="date" />
                    <YAxis dataKey={name}/>
                    <Tooltip />
                    <Line type="monotone" dataKey={name} stroke="#8884d8" activeDot={{ r: 5 }} />
                </LineChart>
                </> 
                : <p>No readings found</p>
            }
        </div>
    );
}