"use client";

import roundToSecondDecimal from "@/utils/RoundToNDecimals";
import { calculateWQI, classifyWQI } from "@/utils/SimpleFuzzyLogicWaterQuality";
import axios from "axios";
import { create } from "domain";
import moment, { min } from "moment";
import Image from "next/image";
import { useSearchParams } from "next/navigation";
import { createRef, useEffect, useMemo, useState } from "react";
import "./page.css";
import Signature from "@/components/Signature";


type minMaxTimeStampObject = {
    min: number,
    max: number,
    average?: number,
    minTimestamp?: string,
    maxTimestamp?: string,
}

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
        // api/water-quality?pond_id=???
        axios.get(`/api/pond/current-readings?pond_id=${pond_id}`).then((response: any) => {
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
        const temp: {
            temperature: minMaxTimeStampObject,
            ph: minMaxTimeStampObject,
            tds: minMaxTimeStampObject,
            ammonia: minMaxTimeStampObject,
        } = {
            temperature: {
                min: waterQualityReadings.reduce((acc, curr) => Math.min(acc, curr.temperature), Infinity),
                max: waterQualityReadings.reduce((acc, curr) => Math.max(acc, curr.temperature), -Infinity),
                average: roundToSecondDecimal(waterQualityReadings.reduce((acc, curr) => acc + curr.temperature, 0) / waterQualityReadings.length),
            },
            ph: {
                min: waterQualityReadings.reduce((acc, curr) => Math.min(acc, curr.ph), Infinity),
                max: waterQualityReadings.reduce((acc, curr) => Math.max(acc, curr.ph), -Infinity),
                average: roundToSecondDecimal(waterQualityReadings.reduce((acc, curr) => acc + curr.ph, 0) / waterQualityReadings.length),
            },
            tds: {
                min: waterQualityReadings.reduce((acc, curr) => Math.min(acc, curr.tds), Infinity),
                max: waterQualityReadings.reduce((acc, curr) => Math.max(acc, curr.tds), -Infinity),
                average: roundToSecondDecimal(waterQualityReadings.reduce((acc, curr) => acc + curr.tds, 0) / waterQualityReadings.length),
            },
            ammonia: {
                min: waterQualityReadings.reduce((acc, curr) => Math.min(acc, curr.ammonia), Infinity),
                max: waterQualityReadings.reduce((acc, curr) => Math.max(acc, curr.ammonia), -Infinity),
                average: roundToSecondDecimal(waterQualityReadings.reduce((acc, curr) => acc + curr.ammonia, 0) / waterQualityReadings.length),
            },
        };
        temp.temperature.minTimestamp = waterQualityReadings.find((reading) => reading.temperature === temp.temperature.min)?.timestamp;
        temp.temperature.maxTimestamp = waterQualityReadings.find((reading) => reading.temperature === temp.temperature.max)?.timestamp;
        temp.ph.minTimestamp = waterQualityReadings.find((reading) => reading.ph === temp.ph.min)?.timestamp;
        temp.ph.maxTimestamp = waterQualityReadings.find((reading) => reading.ph === temp.ph.max)?.timestamp;
        temp.tds.minTimestamp = waterQualityReadings.find((reading) => reading.tds === temp.tds.min)?.timestamp;
        temp.tds.maxTimestamp = waterQualityReadings.find((reading) => reading.tds === temp.tds.max)?.timestamp;
        temp.ammonia.minTimestamp = waterQualityReadings.find((reading) => reading.ammonia === temp.ammonia.min)?.timestamp;
        temp.ammonia.maxTimestamp = waterQualityReadings.find((reading) => reading.ammonia === temp.ammonia.max)?.timestamp;
        return temp;
    }, [waterQualityReadings])

    return <div className="max-w-full h-full flex flex-col items-center bg-white">
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
                <table className="max-w-[200px]">
                    <thead className="border-0 border-b border-black">
                        <tr>
                            <th className="text-[14px] font-medium">Number of Recorded Readings</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td className="text-center">
                                {waterQualityReadings?.length}
                            </td>
                        </tr>
                    </tbody>
                </table>
                <table>
                    <thead className="border-0 border-b border-black">
                        <tr>
                            <th className="text-[14px] font-medium">Parameters</th>
                            <th className="text-[14px] font-medium">Average</th>
                            <th className="text-[14px] font-medium">Min.</th>
                            <th className="text-[14px] font-medium">Date</th>
                            <th className="text-[14px] font-medium">Time</th>
                            <th className="text-[14px] font-medium">Max.</th>
                            <th className="text-[14px] font-medium">Date</th>
                            <th className="text-[14px] font-medium">Time</th>
                        </tr>
                    </thead>
                    <tbody>
                        { waterQualityReadings?.length > 0 && <><tr>
                            <td className="text-start">Temperature</td>
                            <td className="text-end">{minMaxes.temperature.average}</td>
                            <td className="text-end">{roundToSecondDecimal(minMaxes.temperature.min)}</td>
                            <td className="text-end">{moment(minMaxes.temperature.minTimestamp).format("MMM DD, yyyy")}</td>
                            <td className="text-end">{moment(minMaxes.temperature.minTimestamp).format("hh:mm a")}</td>
                            <td className="text-end">{roundToSecondDecimal(minMaxes.temperature.max)}</td>
                            <td className="text-end">{moment(minMaxes.temperature.maxTimestamp).format("MMM DD, yyyy")}</td>
                            <td className="text-end">{moment(minMaxes.temperature.minTimestamp).format("hh:mm a")}</td>
                        </tr>
                        <tr>
                            <td className="text-start">pH</td>
                            <td className="text-end">{minMaxes.ph.average}</td>
                            <td className="text-end">{roundToSecondDecimal(minMaxes.ph.min)}</td>
                            <td className="text-end">{moment(minMaxes.ph.minTimestamp).format("MMM DD, yyyy")}</td>
                            <td className="text-end">{moment(minMaxes.ph.minTimestamp).format("hh:mm a")}</td>
                            <td className="text-end">{roundToSecondDecimal(minMaxes.ph.max)}</td>
                            <td className="text-end">{moment(minMaxes.ph.maxTimestamp).format("MMM DD, yyyy")}</td>
                            <td className="text-end">{moment(minMaxes.ph.maxTimestamp).format("hh:mm a")}</td>
                        </tr>
                        <tr>
                            <td className="text-start">Ammonia</td>
                            <td className="text-end">{minMaxes.ammonia.average}</td>
                            <td className="text-end">{roundToSecondDecimal(minMaxes.ammonia.min)}</td>
                            <td className="text-end">{moment(minMaxes.ammonia.minTimestamp).format("MMM DD, yyyy")}</td>
                            <td className="text-end">{moment(minMaxes.ammonia.minTimestamp).format("hh:mm a")}</td>
                            <td className="text-end">{roundToSecondDecimal(minMaxes.ammonia.max)}</td>
                            <td className="text-end">{moment(minMaxes.ammonia.maxTimestamp).format("MMM DD, yyyy")}</td>
                            <td className="text-end">{moment(minMaxes.ammonia.maxTimestamp).format("hh:mm a")}</td>
                        </tr>
                        <tr>
                            <td className="text-start">Total Dissolved Solids</td>
                            <td className="text-end">{minMaxes.tds.average}</td>
                            <td className="text-end">{roundToSecondDecimal(minMaxes.tds.min)}</td>
                            <td className="text-end">{moment(minMaxes.tds.minTimestamp).format("MMM DD, yyyy")}</td>
                            <td className="text-end">{moment(minMaxes.tds.minTimestamp).format("hh:mm a")}</td>
                            <td className="text-end">{roundToSecondDecimal(minMaxes.tds.max)}</td>
                            <td className="text-end">{moment(minMaxes.tds.maxTimestamp).format("MMM DD, yyyy")}</td>
                            <td className="text-end">{moment(minMaxes.tds.maxTimestamp).format("hh:mm a")}</td>
                        </tr></>}
                    </tbody>
                </table>
                <p className="font-medium">AVERAGE WATER QUALITY &nbsp; - &nbsp; {
                    roundToSecondDecimal(
                        calculateWQI({
                            ph: minMaxes?.ph?.average || 0,
                            tds: minMaxes?.tds?.average || 0,
                            ammonia: minMaxes?.ammonia?.average || 0,
                            temperature: minMaxes?.temperature?.average || 0,
                        }) * 100
                    )
                }% ({
                        classifyWQI(
                            calculateWQI({
                                ph: minMaxes?.ph?.average || 0,
                                tds: minMaxes?.tds?.average || 0,
                                ammonia: minMaxes?.ammonia?.average || 0,
                                temperature: minMaxes?.temperature?.average || 0,
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
}