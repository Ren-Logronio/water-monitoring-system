/* eslint-disable jsx-a11y/alt-text */
/* eslint-disable @next/next/no-img-element */

import axios from "axios";
import { createRef, useCallback, useEffect, useLayoutEffect, useState } from "react";
import { NinetyRing } from "react-svg-spinners";
import { Button } from "../ui/button";
import moment from "moment";
import ParameterGraph from "./Parameter/Parameter.graph";
import { useRouter } from "next/navigation";
import { DropdownMenu, DropdownMenuContent, DropdownMenuLabel, DropdownMenuRadioGroup, DropdownMenuRadioItem, DropdownMenuSeparator, DropdownMenuTrigger } from "../ui/dropdown-menu";


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

export default function Parameter({ parameter, hideCallback }: { parameter: any, hideCallback: (parameter: any) => void }) {
    const [readings, setReadings] = useState<any[]>([]);
    const [hover, setHover] = useState<boolean>(false);
    const [loading, setLoading] = useState(true);
    const [thresholds, setThresholds] = useState<any[]>([]);
    const containingDiv = createRef<HTMLDivElement>();
    const [aggregation, setAggregation] = useState<"minutes" | "hour" | "day" | "week" | "month">("hour");
    const [action, setAction] = useState<"ALRT" | "WARN" | "INFO" | "NONE">("NONE");
    const router = useRouter();
    // const chartDimensions = useDimensions(containingDiv);

    useEffect(() => {
        axios.get(`/api/reading?parameter_id=${parameter.parameter_id}`).then((response) => {
            if (response.data.results && response.data.results.length > 0) {
                setReadings(response.data.results.sort((a: any, b: any) => moment(a.recorded_at).diff(b.recorded_at)));
            }
            axios.get(`/api/threshold?parameter=${parameter.parameter}`).then((response) => {
                setThresholds(response.data.results);
            }).catch((error) => {
                console.log(error);
            }).finally(() => {
                setLoading(false);
            });
        }).catch((error) => {
            console.error(error);
        });
        const readingsInterval = setInterval(() => {
            axios.get(`/api/reading?parameter_id=${parameter.parameter_id}`).then((response) => {
                if (response.data.results && response.data.results.length > 0) {
                    setReadings(response.data.results.sort((a: any, b: any) => moment(a.recorded_at).diff(b.recorded_at)));
                }
                axios.get(`/api/threshold?parameter=${parameter.parameter}`).then((response) => {
                    setThresholds(response.data.results);
                }).catch((error) => {
                    console.log(error);
                }).finally(() => {
                    setLoading(false);
                });
            }).catch((error) => {
                console.error(error);
            });
        }, 10000);
        return () => clearInterval(readingsInterval);
    }, [parameter]);

    useEffect(() => {
        if (loading) return;
        const triggeredThresholdActions = thresholds.filter((threshold) => {
            if (threshold.type === "GT") {
                //return readings.some((reading) => reading.value > threshold.target);
                return readings[readings.length - 1].value > threshold.target;
            } else if (threshold.type === "LT") {
                //return readings.some((reading) => reading.value < threshold.target);
                return readings[readings.length - 1].value < threshold.target;
            }
        });
        if(triggeredThresholdActions.find(threshold => threshold.action === "INFO")) {
            setAction("INFO");
            return;
        }
        if(triggeredThresholdActions.find(threshold => threshold.action === "WARN")) {
            setAction("WARN");
            return;
        };
        if(triggeredThresholdActions.find(threshold => threshold.action === "ALRT")) { 
            setAction("ALRT");
            return;
        };
        setAction("NONE");
    }, [readings, thresholds, loading]);

    useEffect(() => {
        console.log("action", action);
    }, [action]);

    // update the hover state when mouse enters and leaves the div
    const handleMouseEnter = () => {
        setHover(true);
    }
    
    const handleMouseLeave = () => {
        setHover(false);
    }

    return (
        <div ref={containingDiv} onMouseEnter={handleMouseEnter} onMouseLeave={handleMouseLeave}
            className={`${readings.length <= 0 ? "hidden" : "select-none relative rounded-[var(--radius)] overflow-hidden flex min-h-[352px] bg-white shadow-md hover:shadow-lg flex-col justify-center items-center"} `}>

            {/* Loading spinner */}
            {loading && <NinetyRing />}

            {/* Parameter details */}
            {!loading && readings.length > 0 &&
                <>
                    <div className={`absolute z-40 size-full flex flex-col justify-end transition-all ${hover ? 'opacity-0 pointer-events-none' : 'opacity-100'}`}>
                        <div className={`${action === "ALRT" ? `text-red-900` : action === "WARN" ? `text-orange-900` : "text-blue-900"} mx-7 mb-4`}>
                            <h1 className="text-[20px] leading-[28px] font-medium">{parameter.name}</h1>
                            <div className="flex flex-row items-center space-x-2">
                                <p className="text-[40px] leading-[32px] m-0 font-semibold">{readings[readings.length - 1].value}</p>
                                <p className="text-[32px] leading-[26px] m-0 font-semibold">{parameter.unit}</p>
                            </div>
                            <p className="text-[14px] font-normal m-0">Last recorded reading</p>
                        </div>
                    </div>
                    <img src={action === "ALRT" ? `./gradient-red.png` : action === "WARN" ? `./gradient-yellow.png` : `./gradient-blue.png`} className={`absolute bottom-0 left-0 z-30 ${hover ? 'opacity-0 pointer-events-none' : 'opacity-100'}`} />

                    {/* Graph action buttons */}
                    <div className={`absolute z-40 top-0 left-0 min-w-full min-h-[20px] flex flex-row justify-end pt-2 pr-2`}>
                        <DropdownMenu>
                            <DropdownMenuTrigger>
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="#354f94" className="w-6 h-6">
                                <path strokeLinecap="round" strokeLinejoin="round" d="M12 3c2.755 0 5.455.232 8.083.678.533.09.917.556.917 1.096v1.044a2.25 2.25 0 0 1-.659 1.591l-5.432 5.432a2.25 2.25 0 0 0-.659 1.591v2.927a2.25 2.25 0 0 1-1.244 2.013L9.75 21v-6.568a2.25 2.25 0 0 0-.659-1.591L3.659 7.409A2.25 2.25 0 0 1 3 5.818V4.774c0-.54.384-1.006.917-1.096A48.32 48.32 0 0 1 12 3Z" />
                                </svg>
                            </DropdownMenuTrigger>
                            <DropdownMenuContent className="w-56">
                                <DropdownMenuLabel>Grouping</DropdownMenuLabel>
                                <DropdownMenuSeparator />
                                <DropdownMenuRadioGroup value={aggregation} onValueChange={(value: any) => setAggregation(value)}>
                                    <DropdownMenuRadioItem value="minutes">Minutes</DropdownMenuRadioItem>
                                    <DropdownMenuRadioItem value="hour">Hourly</DropdownMenuRadioItem>
                                    <DropdownMenuRadioItem value="day">Daily</DropdownMenuRadioItem>
                                    <DropdownMenuRadioItem value="week">Weekly</DropdownMenuRadioItem>
                                    <DropdownMenuRadioItem value="month">Monthly</DropdownMenuRadioItem>
                                </DropdownMenuRadioGroup>
                            </DropdownMenuContent>
                        </DropdownMenu>
                        
                        <Button onClick={() => hideCallback(parameter)} variant="ghost" className="p-2">
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="#354f94" className="w-6 h-6">
                                <path strokeLinecap="round" strokeLinejoin="round" d="M2.036 12.322a1.012 1.012 0 0 1 0-.639C3.423 7.51 7.36 4.5 12 4.5c4.638 0 8.573 3.007 9.963 7.178.07.207.07.431 0 .639C20.577 16.49 16.64 19.5 12 19.5c-4.638 0-8.573-3.007-9.963-7.178Z" />
                                <path strokeLinecap="round" strokeLinejoin="round" d="M15 12a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z" />
                            </svg>
                        </Button>

                        <Button onClick={() => router.push(`/parameter/${parameter.parameter.toLowerCase() === "tds" ? "tds" : parameter.name.toLowerCase()}/datasheet`)} variant="ghost" className="p-2">
                            <img src="./edit-logo.png" className="size-5" />
                        </Button>
                        {/* <Button variant="ghost" className="p-2">
                            <img src="./print-logo.png" className="size-5" />
                        </Button>
                        <Button variant="ghost" className="p-2">
                            <img src="./gear-logo.png" className="size-5" />
                        </Button> */}
                    </div>

                    {/* Parameter graphs */}
                    <ParameterGraph readings={readings} parameter={parameter} hover={hover} thresholds={thresholds} aggregation={aggregation} />
                </>
            }

            {/* No readings found */}
            {!loading && readings.length <= 0 &&
                <>
                    <p>No {parameter.name} readings found</p>
                </>
            }

        </div>
    );
}