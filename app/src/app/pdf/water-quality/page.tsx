"use client";

import roundToSecondDecimal from "@/utils/RoundToNDecimals";
import { calculateWQI, classifyWQI } from "@/utils/SimpleFuzzyLogicWaterQuality";
import axios from "axios";
import { create } from "domain";
import moment from "moment";
import Image from "next/image";
import { useSearchParams } from "next/navigation";
import { createRef, useEffect, useMemo, useState } from "react";
import "./page.css";
import Signature from "@/components/Signature";

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
        axios.get(`/api/water-quality?pond_id=${pond_id}`).then((response: any) => {
            console.log("knknkjn", response.data.results);
            !!response.data.results?.length && setWaterQualityReadings(
                response.data.results
                    .filter(
                        (result: any) => moment(result.timestamp).isBetween(moment(dateFrom), moment(dateTo).add(1, "hour"), "hour")
                    ).map((result: any) => {
                        const wqi = calculateWQI({
                            ph: result.ph,
                            temperature: result.temperature,
                            ammonia: result.ammonia,
                            tds: result.tds,
                        });
                        const classification = classifyWQI(wqi);
                        return { ...result, wqi: roundToSecondDecimal(wqi * 100), classification };
                    })
            );
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
        const timeout = setTimeout(async () => {
            window.onafterprint = () => {
                window.close();
            }
            window.print();
        }, 100);
        return () => {
            clearTimeout(timeout);
        };
    }, [loading]);

    const maxTemperature = useMemo
    const minMaxes = useMemo(() => {
        return {
            temperature: {
                min: waterQualityReadings.reduce((acc, curr) => Math.min(acc, curr.temperature), Infinity),
                max: waterQualityReadings.reduce((acc, curr) => Math.max(acc, curr.temperature), -Infinity),
            },
            ph: {
                min: waterQualityReadings.reduce((acc, curr) => Math.min(acc, curr.ph), Infinity),
                max: waterQualityReadings.reduce((acc, curr) => Math.max(acc, curr.ph), -Infinity),
            }
        }
    }, [waterQualityReadings])

    return (
        <div className="max-w-full h-full flex flex-col items-center bg-white">
            <title>{`Water Quality Report ${moment().format("MMM-DD-yyyy_h:mm-a")}`}</title>
            <div ref={printableRef} className="flex flex-col min-w-[800px] max-w-[800px] h-screen mx-auto bg-white p-4 space-y-9">
                {
                    loading && <div className="w-full h-full flex-1 flex justify-center items-center">Please Wait...</div>
                }
                {!loading && <>
                    <div className="flex flex-row justify-between">
                        <Image src="/logo-msugensan.png" alt="logo" width={100} height={100} />
                        <div className="flex flex-col justify-center items-center">
                            {/* <span>Mindanao State University - General Santos</span> */}
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
                            Date Generated: {moment().format("MMM DD, yyyy, h:mm a")}
                        </p>
                    </div>
                    <table>
                        <thead className="border-0 border-b border-black">
                            <tr>
                                <th className="text-[14px] font-medium">Number of Recorded Readings</th>
                                <th className="text-[14px] font-medium">Parameters</th>
                                <th className="text-[14px] font-medium">Min.</th>
                                <th className="text-[14px] font-medium">Max.</th>
                                <th className="text-[14px] font-medium">Average</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td className="text-center">{waterQualityReadings.length}</td>
                                <td className="text-start">Temperature</td>
                                <td className="text-end">{ }</td>
                                <td className="text-end">{roundToSecondDecimal(0)}</td>
                                <td className="text-end">{roundToSecondDecimal(waterQualityReadings.reduce((acc, curr) => acc + curr.temperature, 0) / waterQualityReadings.length)}</td>
                            </tr>
                            <tr>
                                <td className="text-end"></td>
                                <td className="text-start">pH</td>
                                <td className="text-end">{roundToSecondDecimal(waterQualityReadings.reduce((acc, curr) => Math.min(acc, curr.ph), Infinity))}</td>
                                <td className="text-end">{roundToSecondDecimal(waterQualityReadings.reduce((acc, curr) => Math.max(acc, curr.ph), -Infinity))}</td>
                                <td className="text-end">{roundToSecondDecimal(waterQualityReadings.reduce((acc, curr) => acc + curr.ph, 0) / waterQualityReadings.length)}</td>
                            </tr>
                            <tr>
                                <td className="text-end"></td>
                                <td className="text-start">Ammonia</td>
                                <td className="text-end">{roundToSecondDecimal(waterQualityReadings.reduce((acc, curr) => Math.min(acc, curr.ammonia), Infinity))}</td>
                                <td className="text-end">{roundToSecondDecimal(waterQualityReadings.reduce((acc, curr) => Math.max(acc, curr.ammonia), -Infinity))}</td>
                                <td className="text-end">{roundToSecondDecimal(waterQualityReadings.reduce((acc, curr) => acc + curr.ammonia, 0) / waterQualityReadings.length)}</td>
                            </tr>
                            <tr>
                                <td className="text-end"></td>
                                <td className="text-start">Total Dissolved Solids</td>
                                <td className="text-end">{roundToSecondDecimal(waterQualityReadings.reduce((acc, curr) => Math.min(acc, curr.tds), Infinity))}</td>
                                <td className="text-end">{roundToSecondDecimal(waterQualityReadings.reduce((acc, curr) => Math.max(acc, curr.tds), -Infinity))}</td>
                                <td className="text-end">{roundToSecondDecimal(waterQualityReadings.reduce((acc, curr) => acc + curr.tds, 0) / waterQualityReadings.length)}</td>
                            </tr>
                        </tbody>
                    </table>
                    <p className="font-medium">CURRENT WATER QUALITY &nbsp; - &nbsp; {
                        roundToSecondDecimal(
                            calculateWQI({
                                ph: waterQualityReadings[0].ph,
                                tds: waterQualityReadings[0].tds,
                                ammonia: waterQualityReadings[0].ammonia,
                                temperature: waterQualityReadings[0].temperature
                            }) * 100
                        )
                    }% ({
                            classifyWQI(
                                calculateWQI({
                                    ph: waterQualityReadings[0].ph,
                                    tds: waterQualityReadings[0].tds,
                                    ammonia: waterQualityReadings[0].ammonia,
                                    temperature: waterQualityReadings[0].temperature
                                })
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
                                <th className="text-[14px] font-medium">Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            {
                                waterQualityReadings.map((reading, index) => {
                                    return <tr key={index}>
                                        <td className="text-center">{moment(reading.timestamp).format("MMM DD, yyyy")}</td>
                                        <td className="text-center">{moment(reading.timestamp).format("h:mm a")}</td>
                                        <td className="text-center">{reading.temperature} °C</td>
                                        <td className="text-center">{reading.ph}</td>
                                        <td className="text-center">{reading.ammonia} ppm</td>
                                        <td className="text-center">{reading.tds} ppm</td>
                                        <td className="text-center">{reading.wqi}</td>
                                        <td className="text-center">{reading.classification}</td>
                                    </tr>
                                })
                            }
                        </tbody>
                    </table>
                    <Signature />
                </>}
            </div>
        </div>
    )
}