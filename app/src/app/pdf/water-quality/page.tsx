"use client";

import roundToSecondDecimal from "@/utils/RoundToNDecimals";
import { calculateWQI, classifyWQI } from "@/utils/SimpleFuzzyLogicWaterQuality";
import axios from "axios";
import { create } from "domain";
import moment from "moment";
import Image from "next/image";
import { useSearchParams } from "next/navigation";
import { createRef, useEffect, useState } from "react";
import "./page.css";

export default function PrintWaterQuality() {
    const printableRef = createRef<HTMLDivElement>();
    const searchParams = useSearchParams();
    const [farm, setFarm] = useState<any>(null);
    const [loading, setLoading] = useState<boolean>(true);
    const [waterQualityReadings, setWaterQualityReadings] = useState<any[]>([]);
    const pond_id = searchParams.get("pond_id");
    const dateFrom = searchParams.get("from");
    const dateTo = searchParams.get("to");

    useEffect(() => {
        axios.get(`/api/pond/current-readings?pond_id=${pond_id}`).then((response: any) => {
            !!response.data.results?.length && setWaterQualityReadings(response.data.results.filter((result: any) => moment(result.recorded_at).isBetween(moment(dateFrom), moment(dateTo).add(1, "hour"), "hour")));
            axios.get(`/api/pond/farm?pond_id=${pond_id}`).then(response => {
                if (response.data.result) {
                    setFarm(response.data.result);
                }
            }).catch(error => {
                console.error(error);
            }).finally(() => {
                setLoading(false);
            });
        }).catch(error => {
            console.error(error);
        })
    }, []);

    useEffect(() => {
        if (loading || !printableRef?.current) return;
        const timeout = setTimeout( async () => {
            window.onafterprint = () => {
                window.close();
            }
            window.print();
        }, 100);
        return () => {
            clearTimeout(timeout);
        };
    }, [loading]);

    return <div className="max-w-full h-full flex flex-col items-center bg-white">
        <title>{`Water Quality Report ${moment().format("MMM-DD-yyyy_h:mm-a")}`}</title>
        <div ref={printableRef} className="flex flex-col min-w-[800px] max-w-[800px] h-screen mx-auto bg-white p-4 space-y-9">
            {
                loading && <div className="w-full h-full flex-1 flex justify-center items-center">Please Wait...</div>
            }
            { !loading && <>
                <div className="flex flex-row justify-between">
                    <Image src="/logo-msugensan.png" alt="logo" width={100} height={100} />
                    <div className="flex flex-col justify-center items-center">
                        <span className="text-center">{farm?.farm_name}</span>
                        <span className="text-center"> {[farm?.address_street, farm?.address_city, farm?.address_province].join(", ") || "Mindanao State University General Santos"}</span>
                    </div>
                    <div className="size-[100px]"></div>
                </div>
                <p className="text-center text-[16px] font-semibold">{farm?.pond_name} Water Quality Report</p>
                <div className="flex flex-row justify-between">
                    <p>
                        Date Range: {!moment(searchParams.get("from")).isSame(moment.unix(0)) ? `${moment(searchParams.get("from")).format("MMM DD, yyyy")} to` : " Until"} {moment(searchParams.get("to")).format("MMM DD, yyyy")}
                    </p>
                    <p>
                        Date: {moment().format("MMM DD, yyyy, h:mm a")}
                    </p>
                </div>
                <table>
                    <thead className="border-0 border-b border-black">
                        <tr>
                            <th className="text-[14px] font-medium">Sample Size</th>
                            <th className="text-[14px] font-medium">Parameters</th>
                            <th className="text-[14px] font-medium">Min.</th>
                            <th className="text-[14px] font-medium">Max.</th>
                            <th className="text-[14px] font-medium">Mean</th>
                            <th className="text-[14px] font-medium">Std. Deviation</th>
                            <th className="text-[14px] font-medium">Rate Of Change</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td className="text-center">{waterQualityReadings.length}</td>
                            <td className="text-start">Temperature</td>
                            <td className="text-end">{roundToSecondDecimal(waterQualityReadings.reduce((acc, curr) => Math.min(acc, curr.temperature), Infinity))}</td>
                            <td className="text-end">{roundToSecondDecimal(waterQualityReadings.reduce((acc, curr) => Math.max(acc, curr.temperature), -Infinity))}</td>
                            <td className="text-end">{roundToSecondDecimal(waterQualityReadings.reduce((acc, curr) => acc + curr.temperature, 0) / waterQualityReadings.length)}</td>
                            <td className="text-end">{roundToSecondDecimal(Math.sqrt(waterQualityReadings.reduce((acc, curr) => acc + Math.pow(curr.temperature - (waterQualityReadings.reduce((acc, curr) => acc + curr.temperature, 0) / waterQualityReadings.length), 2), 0) / waterQualityReadings.length))}</td>
                            <td className="text-end">{roundToSecondDecimal((waterQualityReadings[0].temperature - waterQualityReadings[waterQualityReadings.length - 1].temperature) / waterQualityReadings.length)}</td>
                        </tr>
                        <tr>
                            <td className="text-end"></td>
                            <td className="text-start">pH</td>
                            <td className="text-end">{roundToSecondDecimal(waterQualityReadings.reduce((acc, curr) => Math.min(acc, curr.ph), Infinity))}</td>
                            <td className="text-end">{roundToSecondDecimal(waterQualityReadings.reduce((acc, curr) => Math.max(acc, curr.ph), -Infinity))}</td>
                            <td className="text-end">{roundToSecondDecimal(waterQualityReadings.reduce((acc, curr) => acc + curr.ph, 0) / waterQualityReadings.length)}</td>
                            <td className="text-end">{roundToSecondDecimal(Math.sqrt(waterQualityReadings.reduce((acc, curr) => acc + Math.pow(curr.ph - (waterQualityReadings.reduce((acc, curr) => acc + curr.ph, 0) / waterQualityReadings.length), 2), 0) / waterQualityReadings.length))}</td>
                            <td className="text-end">{roundToSecondDecimal((waterQualityReadings[0].ph - waterQualityReadings[waterQualityReadings.length - 1].ph) / waterQualityReadings.length)}</td>
                        </tr>
                        <tr>
                            <td className="text-end"></td>
                            <td className="text-start">Ammonia</td>
                            <td className="text-end">{roundToSecondDecimal(waterQualityReadings.reduce((acc, curr) => Math.min(acc, curr.ammonia), Infinity))}</td>
                            <td className="text-end">{roundToSecondDecimal(waterQualityReadings.reduce((acc, curr) => Math.max(acc, curr.ammonia), -Infinity))}</td>
                            <td className="text-end">{roundToSecondDecimal(waterQualityReadings.reduce((acc, curr) => acc + curr.ammonia, 0) / waterQualityReadings.length)}</td>
                            <td className="text-end">{roundToSecondDecimal(Math.sqrt(waterQualityReadings.reduce((acc, curr) => acc + Math.pow(curr.ammonia - (waterQualityReadings.reduce((acc, curr) => acc + curr.ammonia, 0) / waterQualityReadings.length), 2), 0) / waterQualityReadings.length))}</td>
                            <td className="text-end">{roundToSecondDecimal((waterQualityReadings[0].ammonia - waterQualityReadings[waterQualityReadings.length - 1].ammonia) / waterQualityReadings.length)}</td>
                        </tr>
                        <tr>
                            <td className="text-end"></td>
                            <td className="text-start">Total Dissolved Solids</td>
                            <td className="text-end">{roundToSecondDecimal(waterQualityReadings.reduce((acc, curr) => Math.min(acc, curr.tds), Infinity))}</td>
                            <td className="text-end">{roundToSecondDecimal(waterQualityReadings.reduce((acc, curr) => Math.max(acc, curr.tds), -Infinity))}</td>
                            <td className="text-end">{roundToSecondDecimal(waterQualityReadings.reduce((acc, curr) => acc + curr.tds, 0) / waterQualityReadings.length)}</td>
                            <td className="text-end">{roundToSecondDecimal(Math.sqrt(waterQualityReadings.reduce((acc, curr) => acc + Math.pow(curr.tds - (waterQualityReadings.reduce((acc, curr) => acc + curr.tds, 0) / waterQualityReadings.length), 2), 0) / waterQualityReadings.length))}</td>
                            <td className="text-end">{roundToSecondDecimal((waterQualityReadings[0].tds - waterQualityReadings[waterQualityReadings.length - 1].tds) / waterQualityReadings.length)}</td>
                        </tr>
                    </tbody>
                </table>
                <p className="font-medium">CURRENT WATER QUALITY &nbsp; - &nbsp; {
                    roundToSecondDecimal(
                        calculateWQI(
                            waterQualityReadings[0].ph,
                            waterQualityReadings[0].tds,
                            waterQualityReadings[0].ammonia,
                            waterQualityReadings[0].temperature, 
                        ) * 100
                    )
                }% ({
                    classifyWQI(
                        calculateWQI(
                            waterQualityReadings[0].ph,
                            waterQualityReadings[0].tds,
                            waterQualityReadings[0].ammonia,
                            waterQualityReadings[0].temperature, 
                        )
                    )
                }) </p>
                <table>
                    <thead className="border-0 border-b border-black">
                        <tr>
                            <th className="text-[14px] font-medium">Date</th>
                            <th className="text-[14px] font-medium">Time</th>
                            <th className="text-[14px] font-medium">Temperature</th>
                            <th className="text-[14px] font-medium">pH</th>
                            <th className="text-[14px] font-medium">Ammonia</th>
                            <th className="text-[14px] font-medium">TDS</th>
                            <th className="text-[14px] font-medium">Water Quality</th>
                        </tr>
                    </thead>
                    <tbody>
                        {
                            waterQualityReadings.map((reading, index) => {
                                return <tr key={index}>
                                    <td className="text-center">{moment(reading.recorded_at).format("MMM DD, yyyy")}</td>
                                    <td className="text-center">{moment(reading.recorded_at).format("h:mm a")}</td>
                                    <td className="text-center">{reading.temperature} °C</td>
                                    <td className="text-center">{reading.ph}</td>
                                    <td className="text-center">{reading.ammonia} ppm</td>
                                    <td className="text-center">{reading.tds} ppm</td>
                                    <td className="text-center">{roundToSecondDecimal(calculateWQI(reading.ph, reading.tds, reading.ammonia, reading.temperature) * 100)}% ({classifyWQI(calculateWQI(reading.ph, reading.tds, reading.ammonia, reading.temperature))})</td>
                                </tr>
                            })
                        }
                    </tbody>
                </table>
            </>}
        </div>
    </div>
}