import axios from "axios";
import { useEffect, useMemo, useRef, useState } from "react";
import { NinetyRing } from "react-svg-spinners";
import Parameter from "./Parameter";
import { Badge } from "../ui/badge";
import { calculateWQI, classifyWQI, wqiClassificationColorHex } from "@/utils/SimpleFuzzyLogicWaterQuality";
import { PieChart, Pie } from "recharts";
import Image from "next/image";
import roundToSecondDecimal from "@/utils/RoundToNDecimals";

export default function PondView({ pond_id }: { pond_id?: string }) {
    const [parameters, setParameters] = useState<any[]>([]);
    const [loading, setLoading] = useState(true);
    const [currentReadings, setCurrentReadings] = useState<any[]>([]);
    const [averageReadings, setAverageReadings] = useState<any[]>([]);
    const intervalRef = useRef<any>(null);

    useEffect(() => {
        setParameters([]);
        setAverageReadings([]);
        setCurrentReadings([]);
        clearInterval(intervalRef.current);
        setLoading(true);
        // get parameters from the server
        axios.get(`/api/parameter?pond_id=${pond_id}`).then(async (response: any) => {
            // if no parameters found
            if (!response.data.results || response.data.results.length <= 0) {
                setParameters([]);
                return;
            }
            setParameters(response.data.results.map((i: any) => {
                return i.count > 0 ? { ...i, hidden: false, unshowable: false } : { ...i, hidden: true, context: "No Readings", unshowable: true };
            }));
            // get current readings
            await axios.get(`/api/water-quality?pond_id=${pond_id}`).then(response => {
                if (!response.data.results || response.data.results.length <= 0) {
                    return;
                }
                setAverageReadings(response.data.results);
                axios.get(`/api/pond/current-readings?pond_id=${pond_id}`).then(response => {
                    if (!response.data.results || response.data.results.length <= 0) {
                        return;
                    }
                    setCurrentReadings(response.data.results);
                    setLoading(false);
                }).catch((e: any) => {
                    console.error(e);
                }).finally(() => {
                    setLoading(false);
                })
            }).catch((e: any) => {
                console.error(e);
            });
            intervalRef.current = setInterval(() => {
                    axios.get(`/api/pond/current-readings?pond_id=${pond_id}`).then(response => {
                        if (!response.data.results || response.data.results.length <= 0) {
                            return;
                        }
                        setCurrentReadings(response.data.results);
                    }).catch((e: any) => {
                        console.error(e);
                    })
            }, 30000)
        }).catch(error => {
            console.error(error);
        });
        return () => {
            clearInterval(intervalRef.current);
        };
    }, [pond_id]);

    const handleHideParameter = (parameter: any) => {
        setParameters(parameters.map((i: any) => {
            return i.parameter_id === parameter.parameter_id ? { ...i, hidden: true } : i;
        }));
    };

    const handleShowParameter = (parameter: any) => {
        setParameters(parameters.map((i: any) => {
            return i.parameter_id === parameter.parameter_id ? { ...i, hidden: false } : i;
        }));
    };

    useEffect(() => {
        console.log("CURRENT READINGS: ", averageReadings)
    }, [averageReadings])

    return (
        <div className="h-full">
            {/* while fetching data */}
            {loading &&
                <div className="flex justify-center items-center h-40 space-x-2">
                    <NinetyRing width={40} height={40} />
                </div>
            }

            {!loading &&
                // currentReadings.length >= 4 && 
                <div className={`grid mb-2 grid-cols-3 xl:grid-cols-5 gap-7 align-middle items-center ${parameters.every(p => !p?.unshowable) && 'min-h-[200px]'}`}>

                    {/* water quality index */}
                    {parameters.every(p => !p?.unshowable) &&
                        <div className="flex flex-row col-span-3 xl:col-span-2 justify-center items-center border rounded-2xl px-3 relative space-x-7">

                            {currentReadings[0]?.wqi &&
                                <>
                                    <div className="flex flex-col  justify-center items-center">

                                        <PieChart width={200} height={200}>
                                            <Pie
                                                data={[
                                                    { name: 'WQI', value: currentReadings[0]?.wqi * 100, fill: (currentReadings[0]?.classification && wqiClassificationColorHex[currentReadings[0]?.classification] || "#4584B5") },
                                                    { name: 'Rest', value: 100 - (currentReadings[0]?.wqi * 100), fill: "#1A2127" }
                                                ]}
                                                dataKey="value"
                                                cx="50%" cy="70%"
                                                innerRadius={75} outerRadius={95}
                                                fill="#8884d8"
                                                startAngle={180}
                                                endAngle={0} />
                                        </PieChart>

                                        <div className="absolute top-1/2 translate-y-2 flex flex-col justify-center items-center">
                                            <p className="text-[25px] font-semibold">{(currentReadings[0].wqi * 100).toFixed(2)} %</p>
                                        </div>
                                    </div>

                                    <div className="flex flex-col space-y-2 h-full w-[30%] align-middle justify-center">
                                        <p className="text-lg">Water Quality:</p>
                                        <p className={`font-bold text-2xl ${currentReadings[0]?.classification.toString() === "Excellent" && "text-[#00FF00]"} ${currentReadings[0]?.classification.toString() === "Good" && "text-[#00A86B]"} ${currentReadings[0]?.classification.toString() === "Fair" && "text-[#FFD700]"} ${currentReadings[0]?.classification.toString() === "Poor" && "text-[#FFA500]"} ${currentReadings[0]?.classification.toString() === "Very Poor" && "text-[#FF0000]"}`}>{currentReadings[0]?.classification.toString().toUpperCase()}</p>
                                    </div>
                                </>
                            }

                            {!averageReadings[averageReadings.length - 1]?.wqi && parameters.some(p => p?.unshowable) &&
                                <div>
                                    Inconclusive
                                </div>
                            }

                            {!averageReadings[averageReadings.length - 1]?.wqi && !parameters.every(p => !p?.unshowable) &&
                                <div className="flex justify-center items-center h-full space-x-2">
                                    <NinetyRing />
                                </div>
                            }
                        </div>
                    }

                    {/* average readings */}
                    <div className={`col-span-3 h-fit ${parameters.filter(i => !i.hidden).length > 0 ? "hide" : ""}`}>

                        {
                            parameters.some(parameter => !parameter.unshowable) &&
                        <div className="w-full mb-5">
                            <p className="text-[16px]">Average readings last 60 minutes</p>
                        </div>}


                        {/* parameters */}
                        <div className="grid grid-cols-2 2xl:grid-cols-4 gap-x-3 gap-y-3">

                            {/* total dissolved solids */}
                            {parameters.find(p => p?.parameter?.toLowerCase() === "tds") && !parameters.find(p => p?.parameter?.toLowerCase() === "tds").unshowable &&
                                <div className="flex flex-row justify-center items-center border rounded-xl p-3 space-x-5">
                                    <Image src="/icon-particles.png" width={45} height={45} alt="TDS" />

                                    <div className="flex flex-col">
                                        <p className="text-sm">Total Diss. Solids</p>
                                        {averageReadings[averageReadings.length - 1]?.tds &&
                                            <span className="text-[20px] font-semibold">{averageReadings[averageReadings.length - 1]?.tds} ppm</span>
                                        }
                                    </div>

                                    {!averageReadings[averageReadings.length - 1]?.tds &&
                                        <div className="flex justify-center items-center h-full space-x-2">
                                            <NinetyRing />
                                        </div>
                                    }
                                </div>
                            }

                            {/* temperature */}
                            {parameters.find(p => p?.parameter?.toLowerCase() === "tmp") && !parameters.find(p => p?.parameter?.toLowerCase() === "tmp").unshowable &&
                                <div className="flex flex-row justify-center items-center border rounded-xl p-3 space-x-5">
                                    <Image src="/icon-temp.png" width={45} height={45} alt="TDS" />

                                    <div className="flex flex-col">
                                        <p className="text-sm">Temperature</p>
                                        {averageReadings[averageReadings.length - 1]?.temperature &&
                                            <span className="text-[20px] font-semibold">{averageReadings[averageReadings.length - 1]?.temperature} °C</span>
                                        }
                                    </div>

                                    {!averageReadings[averageReadings.length - 1]?.temperature &&
                                        <div className="flex justify-center items-center h-full space-x-2">
                                            <NinetyRing />
                                        </div>
                                    }
                                </div>
                            }

                            {/* pH */}
                            {parameters.find(p => p?.parameter?.toLowerCase() === "ph") && !parameters.find(p => p?.parameter?.toLowerCase() === "ph").unshowable &&
                                <div className="flex flex-row justify-center items-center border rounded-xl p-3 space-x-5">
                                    <Image src="/icon-ph.png" width={45} height={45} alt="TDS" />

                                    <div className="flex flex-col">
                                        <p className="text-sm">pH level</p>
                                        {averageReadings[averageReadings.length - 1]?.ph &&
                                            <span className="text-[20px] font-semibold">{averageReadings[averageReadings.length - 1]?.ph}</span>
                                        }
                                    </div>

                                    {!averageReadings[averageReadings.length - 1]?.ph &&
                                        <div className="flex justify-center items-center h-full space-x-2">
                                            <NinetyRing />
                                        </div>
                                    }
                                </div>
                            }

                            {/* ammonia */}
                            {parameters.find(p => p?.parameter?.toLowerCase() === "amn") && !parameters.find(p => p?.parameter?.toLowerCase() === "amn").unshowable &&
                                <div className="flex flex-row justify-center items-center border rounded-xl p-3 space-x-5">
                                    <Image src="/icon-ammonia.png" width={45} height={45} alt="TDS" />

                                    <div className="flex flex-col">
                                        <p className="text-sm">Ammonia</p>
                                        {averageReadings[averageReadings.length - 1]?.ammonia &&
                                            <span className="text-[20px] font-semibold">{averageReadings[averageReadings.length - 1]?.ammonia} ppm</span>
                                        }
                                    </div>

                                    {!averageReadings[averageReadings.length - 1]?.ammonia &&
                                        <div className="flex justify-center items-center h-full space-x-2">
                                            <NinetyRing />
                                        </div>
                                    }
                                </div>
                            }

                        </div>

                    </div>

                </div>
            }

            {/* if data is fetched and has data for parameters */}
            {!loading && parameters.length > 0 &&
                <>
                    {parameters.filter(i => i.hidden).length > 0 &&
                        <div className="flex flex-row space-x-2 justify-center my-2">
                            {parameters
                                .filter(i => i.hidden)
                                .sort((a, b) => a.unshowable ? 1 : -1)
                                .map(parameter => (
                                    <Badge key={parameter.parameter_id}
                                        variant={parameter.unshowable ? "secondary" : "default"}
                                        className={`${!parameter.unshowable && "cursor-pointer"}`}
                                        onClick={!parameter.unshowable ? () => { handleShowParameter(parameter) } : () => { }}>
                                        {!parameter.unshowable && <>Show</>} {parameter.name} {parameter.unshowable && <>&nbsp; --</>}
                                    </Badge>
                                )
                                )}
                        </div>
                    }

                    {/* if all parameters have data */}
                    {parameters.filter(i => !i.hidden).length > 0 &&
                        <>
                            <div className="transition-all grid grid-cols-1 xl:grid-cols-2 gap-4">
                                {parameters.filter(i => !i.hidden).map(parameter =>
                                    // render parameter component with data
                                    <Parameter
                                        key={parameter.parameter_id}
                                        parameter={parameter}
                                        hideCallback={handleHideParameter} />
                                )
                                }
                            </div>
                        </>
                    }

                    {/* if all parameters have no data */}
                    {parameters.filter(i => i.hidden && i.unshowable).length === parameters.length &&
                        <p className="text-xl text-center m-auto">This pond has no data readings yet</p>
                    }

                    {/** if all params are hidden but have data */}
                    {parameters.filter(i => i.hidden).length === parameters.length && !(parameters.filter(i => i.hidden && i.unshowable).length === parameters.length) &&
                        <p className="text-xl text-center m-auto">No parameters visible, try showing the parameters above</p>
                    }
                </>
            }

            {/* if data is fetched and has no data for parameters */}
            {!loading && parameters.length <= 0 &&
                <p className="text-xl text-center mt-10">No parameters found</p>
            }

        </div>
    );
}