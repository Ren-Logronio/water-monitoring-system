import axios from "axios";
import { format } from "date-fns";
import { createRef, useCallback, useEffect, useLayoutEffect, useState } from "react";
import { NinetyRing } from "react-svg-spinners";
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts';
import { Button } from "../ui/button";

// const useDimensions = (containingDiv: any) => { 
//     const [ chartDimensions, setChartDimensions ] = useState<any>({ width: 0, height: 0 });
//     useEffect(() => {
//         const updateDimensions = (containingDiv: any) => { 
//             if (containingDiv.current) {
//                 console.log("resized")
//                 const { width, height } = containingDiv.current.getBoundingClientRect();
//                 setChartDimensions({ width, height });
//             }
//         }
//         updateDimensions(containingDiv);
//         const event = window.addEventListener('resize', updateDimensions);
//         console.log("event", event);
//         return () => window.removeEventListener('resize', updateDimensions);
//     }, []);

//     return chartDimensions;
// }

export default function Sensor({ sensor_id, name, unit }: { sensor_id: number, name: string, unit: string}) {
    const [readings, setReadings] = useState<any[]>([]);
    const [hover, setHover] = useState<boolean>(false);
    const [ loading, setLoading ] = useState(true);
    const containingDiv = createRef<HTMLDivElement>();
    // const chartDimensions = useDimensions(containingDiv);


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

    const handleMouseEnter = () => {
        setHover(true);
    }

    const handleMouseLeave = () => {
        setHover(false);
    }

    return (
        <div ref={containingDiv} onMouseEnter={handleMouseEnter} onMouseLeave={handleMouseLeave} className="relative rounded-[var(--radius)] overflow-hidden flex min-h-[352px] bg-white flex-col justify-center items-center">
            {
                loading ? <NinetyRing/>
                : readings.length > 0 ? <>
                <div className={`absolute z-40 size-full flex flex-col justify-end transition-all ${ hover ? 'opacity-0 pointer-events-none' : 'opacity-100' }`}>
                    <div className="text-blue-900 mx-7 mb-4">
                        <h1 className="text-[20px] leading-[28px] font-medium">{ name }</h1>
                        <div className="flex flex-row items-center space-x-2">
                            <p className="text-[40px] leading-[32px] m-0 font-semibold">{ readings.sort((a, b) => b.reading_id - a.reading_id)[0].value }</p>
                            <p className="text-[32px] leading-[26px] m-0 font-semibold">{ unit }</p>
                        </div>
                        <p className="text-[14px] font-normal m-0">Last recorded reading</p>
                    </div>
                </div>
                <img src="./gradient-blue.png" className={`absolute bottom-0 left-0 z-30 ${hover ? 'opacity-0 pointer-events-none' : 'opacity-100'}`} />
                <div className={`absolute z-40 top-0 left-0 min-w-full min-h-[20px] flex flex-row justify-end pt-2 pr-2`}>
                    <Button variant="ghost" className="p-2">
                        <img src="./edit-logo.png" className="size-5" />
                    </Button>
                    <Button variant="ghost" className="p-2">
                        <img src="./print-logo.png" className="size-5" />
                    </Button>
                    <Button variant="ghost" className="p-2">
                        <img src="./gear-logo.png" className="size-5" />
                    </Button>
                </div>
                <ResponsiveContainer width="100%" height="100%" className="mt-4">
                    <LineChart
                        data={
                            readings.sort((a, b) => a.reading_id - b.reading_id).map((reading) => {
                                const init: any = {
                                    date: format(reading.recorded_at, "MMM dd"),
                                }
                                init[name] = reading.value.toString();
                                return init
                            })
                        }
                        margin={{ top: 5, right: 30, left: -30, bottom: 5 }}
                        className={`transition-all ${!hover && 'blur-[0.6px]'}`}
                    >
                        <CartesianGrid strokeDasharray="1 1" />
                        <XAxis dataKey="date" color="#aaaaaa"/>
                        <YAxis dataKey={name} color="#aaaaaa"/>
                        <Tooltip />
                        <Line type="monotone" dataKey={name} stroke="#8884d8" activeDot={{ r: 5 }} />
                    </LineChart>
                </ResponsiveContainer>
                </> 
                : <p>No { name} readings found</p>
            }
        </div>
    );
}