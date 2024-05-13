import axios from "axios";
import { useEffect, useMemo, useState } from "react";
import { NinetyRing } from "react-svg-spinners";
import Parameter from "./Parameter";
import { Badge } from "../ui/badge";
import { calculateWQI, classifyWQI, wqiClassificationColorHex } from "@/utils/SimpleFuzzyLogicWaterQuality";
import { PieChart, Pie } from "recharts";

export default function PondView({ pond_id }: { pond_id?: string }) {
    const [parameters, setParameters] = useState<any[]>([]);
    const [loading, setLoading] = useState(true);
    const [currentReadings, setCurrentReadings] = useState<any[]>([]);

    useEffect(() => {
        setParameters([]);
        setCurrentReadings([]);
        setLoading(true);
        // get parameters from the server
        axios.get(`/api/parameter?pond_id=${pond_id}`).then(response => {
            // if no parameters found
            if (!response.data.results || response.data.results.length <= 0) {
                setParameters([]);
                return;
            }
            setParameters(response.data.results.map((i: any) => {
                return i.count > 0 ? { ...i, hidden: false, unshowable: false } : { ...i, hidden: true, context: "No Readings", unshowable: true };
            }));
            response.data.results.forEach(async (parameter: any) => {
                if (parameter.count > 0) {
                    await axios.get(`/api/reading/current?parameter_id=${parameter.parameter_id}`).then(response => {
                        if (!response.data.result) {
                            return;
                        }
                        setCurrentReadings(prev => [...prev.filter((reading) => reading.reading_id !== response.data.result.reading_id), {...response.data.result, ...parameter}]);
                    }).catch(error => {
                        console.error(error);
                    });
                }
            });
        }).catch(error => {
            console.error(error);
        }).finally(() => {
            // set loading state to false
            setLoading(false);
        });
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

    const phCurrentReading = useMemo(() => currentReadings.find((reading) => reading.parameter === "PH"), [currentReadings]);
    // calculate +/-[difference] display is +[difference] or -[difference]
    const phDifference = useMemo(() => { 
        if (phCurrentReading && phCurrentReading.previous_value) {
            const difference = phCurrentReading.value - phCurrentReading.previous_value;
            return difference > 0 ? `+${difference}` : difference;
        }
        return null;
    }, [phCurrentReading]);
    const tempCurrentReading = useMemo(() => currentReadings.find((reading) => reading.parameter === "TMP"), [currentReadings]);
    const tempDifference = useMemo(() => {
        if (tempCurrentReading && tempCurrentReading.previous_value) {
            const difference = tempCurrentReading.value - tempCurrentReading.previous_value;
            return difference > 0 ? `+${difference}` : difference;
        }
        return null;
    }, [tempCurrentReading]);
    const tdsCurrentReading = useMemo(() => currentReadings.find((reading) => reading.parameter === "TDS"), [currentReadings]);
    const tdsDifference = useMemo(() => {
        if (tdsCurrentReading && tdsCurrentReading.previous_value) {
            const difference = tdsCurrentReading.value - tdsCurrentReading.previous_value;
            return difference > 0 ? `+${difference}` : difference;
        }
        return null;
    }, [tdsCurrentReading]);
    const ammoniaCurrentReading = useMemo(() => currentReadings.find((reading) => reading.parameter === "AMN"), [currentReadings]);
    const ammoniaDifference = useMemo(() => {
        if (ammoniaCurrentReading && ammoniaCurrentReading.previous_value) {
            const difference = ammoniaCurrentReading.value - ammoniaCurrentReading.previous_value;
            return difference > 0 ? `+${difference}` : difference;
        }
        return null;
    }, [ammoniaCurrentReading]);

    const wqi = useMemo(() => {
        if (phCurrentReading && tempCurrentReading && tdsCurrentReading && ammoniaCurrentReading) {
            // (ph: number, tds: number, ammonia: number, temperature: number)
            return calculateWQI({ ph: phCurrentReading.value, tds: tdsCurrentReading.value, ammonia: ammoniaCurrentReading.value, temperature: tempCurrentReading.value });
        }
        return null;
    }, [phCurrentReading, tempCurrentReading, tdsCurrentReading, ammoniaCurrentReading]);

    const wqiClassification = useMemo(() => {
        return wqi && classifyWQI(wqi);
    }, [wqi]);

    useEffect(() => {
        console.log("CURRENT READINGS: ", currentReadings)
    }, [currentReadings])

    return (
        <div className="h-full">
            {/* while fetching data */}
            {loading &&
                <div className="flex justify-center items-center h-40 space-x-2">
                    <NinetyRing width={40} height={40} />
                </div>
            }

            {
                !loading && 
                // currentReadings.length >= 4 && 
                <div className={`grid mb-2 grid-cols-3 xl:grid-cols-5 gap-4 ${parameters.every(p => !p?.unshowable) && 'min-h-[200px]'}`}>
                    {
                        parameters.every(p => !p?.unshowable) &&
                        <div className=" flex flex-col justify-center items-center border p-3 relative">
                        {
                            wqi && <>
                                {/* <RadialBarChart data={[{
                                    name: 'WQI',
                                    value: wqi * 100,
                                    fill: '#8884d8',
                                }]} innerRadius={"60%"} outerRadius={"75%"} width={200} height={200} startAngle={180} endAngle={0}>
                                    <RadialBar background dataKey='value' />
                                </RadialBarChart> */}
                                <PieChart width={200} height={150}>
                                    <Pie 
                                        data={[
                                            { name: 'WQI', value: wqi * 100, fill: (wqiClassification && wqiClassificationColorHex[wqiClassification] || "#4584B5")}, 
                                            { name: 'Rest', value: 100 - (wqi * 100), fill: "#1A2127" }
                                        ]} 
                                        dataKey="value"
                                         cx="50%" cy="50%" 
                                         innerRadius={60} outerRadius={75} 
                                         fill="#8884d8" 
                                         startAngle={180} 
                                         endAngle={0} />
                                </PieChart>
                                <div className="absolute top-1/2 -translate-y-6 flex flex-col justify-center items-center">
                                    <p className=" text-[20px]">{(wqi * 100).toFixed(2)} %</p>
                                    <p className=" text-[14px]">Water Quality</p>
                                    <p className=" font-semibold">{wqiClassification}</p>
                                </div>
                            </>
                        }
                        {
                            !wqi && parameters.some(p => p?.unshowable) && <div>
                                Inconclusive
                            </div>
                        }
                        {
                            !wqi && !parameters.every(p => !p?.unshowable) && <div className="flex justify-center items-center h-full space-x-2">
                            <NinetyRing />
                        </div>
                        }
                    </div>}
                    { parameters.find(p => p?.parameter?.toLowerCase() === "tmp") 
                        && !parameters.find(p => p?.parameter?.toLowerCase() === "tmp").unshowable
                        && <div className=" flex flex-col justify-center items-center border p-3">
                        <p className="text-[14px]">Temperature</p>
                        { tempCurrentReading && <>
                            <span className="text-[20px]">{tempCurrentReading.value} °C</span>
                            {!!tempDifference && <span className="text-[12px] mt-1">{tempDifference !== 0 && `(${tempDifference})`}</span>}
                            <span className="text-[12px]">Last recorded reading</span>
                        </>}
                        { !tempCurrentReading && <div className="flex justify-center items-center h-full space-x-2">
                            <NinetyRing />
                        </div>}
                    </div>}
                    {parameters.find(p => p?.parameter?.toLowerCase() === "ph") 
                        && !parameters.find(p => p?.parameter?.toLowerCase() === "ph").unshowable
                        && <div className=" flex flex-col justify-center items-center border p-3">
                        <p className="text-[14px]">pH</p>
                        { phCurrentReading && <>
                            <span className="text-[20px]">{phCurrentReading.value}</span>
                            {!!phDifference && <span className="text-[12px] mt-1">{phDifference !== 0 && `(${phDifference})`}</span>}
                            <span className="text-[12px]">Last recorded reading</span>
                        </>}
                        { !phCurrentReading && <div className="flex justify-center items-center h-full space-x-2">
                            <NinetyRing />
                        </div>}
                    </div>}
                    { parameters.find(p => p?.parameter?.toLowerCase() === "amn") 
                        && !parameters.find(p => p?.parameter?.toLowerCase() === "amn").unshowable
                        && <div className=" flex flex-col justify-center items-center border p-3">
                        <p className="text-[14px]">Ammonia</p>
                        { ammoniaCurrentReading && <>
                            <span className="text-[20px]">{ammoniaCurrentReading.value} ppm</span>
                            {!!ammoniaDifference && <span className="text-[12px] mt-1">{ammoniaDifference !== 0 && `(${ammoniaDifference})`}</span>}
                            <span className="text-[12px]">Last recorded reading</span>
                        </>}
                        { !ammoniaCurrentReading && <div className="flex justify-center items-center h-full space-x-2">
                            <NinetyRing />
                        </div>}
                    </div> }
                    { parameters.find(p => p?.parameter?.toLowerCase() === "tds") 
                        && !parameters.find(p => p?.parameter?.toLowerCase() === "tds").unshowable
                        && <div className=" flex flex-col justify-center items-center border p-3">
                        <p className="text-[14px]">Total Dissolved Solids</p>
                        { tdsCurrentReading && <>
                            <span className="text-[20px]">{tdsCurrentReading.value} ppm</span>
                            {!!tdsDifference && <span className="text-[12px] mt-1">{tdsDifference !== 0 && `(${tdsDifference})`}</span>}
                            <span className="text-[12px]">Last recorded reading</span>
                        </>
                        }
                        { !tdsCurrentReading && <div className="flex justify-center items-center h-full space-x-2">
                            <NinetyRing />
                        </div>}
                    </div>}
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
                                        onClick={!parameter.unshowable ? () => {handleShowParameter(parameter)} : () => {}}>
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
                    {   parameters.filter(i => i.hidden && i.unshowable).length === parameters.length &&
                        <p className="text-xl text-center m-auto">This pond has no data readings yet</p>
                    }

                    {/** if all params are hidden but have data */}
                    {   parameters.filter(i => i.hidden).length === parameters.length && !(parameters.filter(i => i.hidden && i.unshowable).length === parameters.length) &&
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