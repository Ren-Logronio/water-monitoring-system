"use client";

import { AgGridReact } from "ag-grid-react";
import axios from "axios";
import { format } from "date-fns";
import "ag-grid-community/styles/ag-grid.css";
import "ag-grid-community/styles/ag-theme-material.css";
import { useSearchParams, useRouter, useParams } from "next/navigation";
import { createRef, useEffect, useMemo, useState } from "react";
import moment from "moment";
import {
    Table,
    TableBody,
    TableCaption,
    TableCell,
    TableHead,
    TableHeader,
    TableRow,
  } from "@/components/ui/table"
import jsPDF from 'jspdf';
import Image from "next/image";

import "./page.css";
import Signature from "@/components/Signature";

export default function PrintParameter() { 
    const searchParams = useSearchParams();
    const router = useRouter();
    const { parameter } = useParams();
    const [loading, setLoading] = useState(false);
    const [rowData, setRowData] = useState<any[]>([]);
    const [threshold, setThreshold] = useState<any>(null);
    const [farm, setFarm] = useState<any>(null);
    const printableRef = createRef<HTMLDivElement>();

    const pond_id = useMemo(() => {
        return searchParams.get("pond_id");
    }, [searchParams]);

    useEffect(() => {
        if (!pond_id) { 
            router.replace("/dashboard");
            return;
        };
        setLoading(true);
        axios.get(`/api/pond/parameter/reading?pond_id=${pond_id}&parameter=${parameter}`).then(response => {
            if (response.data.results && response.data.results.length > 0) {
                console.log("response.data.results:", response.data.results);
                setRowData(response.data.results.sort((a: any, b: any) => moment(b.recorded_at).diff(a.recorded_at)).filter((reading: any) => moment(reading.recorded_at).isBetween(moment(searchParams.get("from")), moment(searchParams.get("to")))));
            }
            axios.get(`/api/pond/farm?pond_id=${pond_id}`).then(response => {
                if (response.data.result) {
                    setFarm(response.data.result);
                }
                axios.get(`/api/threshold?parameter=${parameter}`).then(response => {
                    if (response.data.results) {
                        setThreshold(response.data.results);
                    }
                }).catch(error => {
                    console.error(error);
                }).finally(() => {
                    setLoading(false);
                });
            }).catch(error => {
                console.error(error);
            })
        }).catch(error => {
            console.error(error);
        });
    }, [pond_id]);

    const min = useMemo(() => {
        return Math.min(...rowData.map((row, idx) => row.value));
    }, [rowData]);

    const max = useMemo(() => {
        return Math.max(...rowData.map((row, idx) => row.value));
    }, [rowData]);

    const aggregatedByHour = useMemo(() => {
        const aggReadings = rowData.map(
            (readings: any) => ({
                ...readings, 
                recorded_at: moment(readings.recorded_at).startOf("hour").format()
            })
        );
        const uniqueTimes = aggReadings.filter(
            (reading: any, index: number, self: any[]) => self.findIndex((r) => moment(r.recorded_at).isSame(reading.recorded_at)) === index
        );
        const aggregatedReadings = uniqueTimes.map(
            (time: any) => {
                const values = aggReadings.filter((reading: any) => moment(reading.recorded_at).isSame(time.recorded_at));
                const average = Math.round((values.reduce((acc: number, curr: any) => acc + curr.value, 0) / values.length) * 100) / 100;
                return { recorded_at: time.recorded_at, value: average };
            }
        );
        return aggregatedReadings;
    }, [rowData]);

    const rateOfChange = useMemo(() => {
        const roundToSecondDecimal = (value: number) => Math.round(value * 100) / 100;
        const meanRateOfChange = roundToSecondDecimal(aggregatedByHour.reduce((acc: number, curr: any, index: number, self: any[]) => {
            if (index === 0) return acc;
            const previous = self[index - 1];
            const rateOfChange = Math.abs((curr.value - previous.value) / (moment(curr.recorded_at).diff(moment(previous.recorded_at), 'hours')));
            return acc + rateOfChange;
        }, 0) / aggregatedByHour.length);
        return meanRateOfChange;
    }, [aggregatedByHour]);

    const mean = useMemo(() => {
        const roundToSecondDecimal = (value: number) => Math.round(value * 100) / 100;
        const mean = roundToSecondDecimal(rowData.reduce((acc: number, curr: any) => acc + curr.value, 0) / rowData.length);
        return mean;
    }, [rowData]);

    const standardDeviation = useMemo(() => {
        const roundToSecondDecimal = (value: number) => Math.round(value * 100) / 100;
        const mean = roundToSecondDecimal(rowData.reduce((acc: number, curr: any) => acc + curr.value, 0) / rowData.length);
        const standardDeviation = roundToSecondDecimal(Math.sqrt(rowData.reduce((acc: number, curr: any) => acc + Math.pow(curr.value - mean, 2), 0) / rowData.length));
        return standardDeviation;
    }, [rowData]);

    const downloadPDF = async (element: HTMLElement) => {
        // Create a new jsPDF instance
        console.log("STARTING DOWNLOAD PDF")
        const doc = new jsPDF({
            orientation: "portrait",
            unit: "px",
            format: "letter",
        });
    
        // Convert the div content to PDF
        const document = doc.html(element);
        document.set({
            html2canvas: { letterRendering: true, width: 8000, scale: 0.1 }
        });
        await document.save(`${parameter}_logs_${moment().format("MMM-DD-yyyy_h:mm-a")}.pdf`);
    }

    useEffect(() => {
        console.log("DIV:", printableRef?.current);
        if (loading && printableRef?.current) return;
        const timeout = setTimeout(async () => {
            window.onafterprint = function(){
                window.close();
            };
            window.print();
            //! FUCKING TRASH library
            // printableRef?.current && await downloadPDF(printableRef.current);
            // window.close();
        }, 10);
        return () => clearTimeout(timeout);
    }, [loading, printableRef])

    return <div className="max-w-full h-full flex flex-col items-center bg-white">
        <title>{parameter} logs {moment().format("MMM-DD-yyyy_h:mm-a")}</title>
        <div ref={printableRef} className="flex flex-col min-w-[800px] max-w-[800px] h-screen mx-auto bg-white p-4 space-y-9">
            {
                loading && <div className="w-full h-full flex-1 flex justify-center items-center">Please Wait...</div>
            }

            { !loading && <>
            
            <div className="flex flex-row justify-between">
                <Image src="/logo-msugensan.png" alt="logo" width={100} height={100} />
                <div className="flex flex-col justify-center items-center">
                    <span className="text-center">{farm?.farm_name}</span>
                    <span className="text-center">{[farm?.address_street, farm?.address_city, farm?.address_province].join(", ") || "Mindanao State University General Santos"}</span>
                </div>
                <div className="size-[100px]"></div>
            </div>
            <p className="text-center text-[16px] font-semibold">{farm?.pond_name} Water {parameter} Logs</p>
            <div className="flex flex-row justify-between">
                <p>
                    Date Range: {!moment(searchParams.get("from")).isSame(moment.unix(0)) ? `${moment(searchParams.get("from")).format("MMM DD, yyyy")} to` : " Until"} {moment(searchParams.get("to")).format("MMM DD, yyyy")}
                </p>
                <p>
                    Date Generated: {moment().format("MMM DD, yyyy, h:mm a")}
                </p>
            </div>
            <table className=" max-w-[500px] border border-black">
                <tbody>
                    <tr className="border-0 border-b border-black">
                        <th className="text-[14px] font-medium border-0 border-r border-black">
                            Min (Date - Time)
                        </th>
                        <td className="text-center">
                            {min} {rowData[0]?.unit} ({moment(rowData.find((reading: any) => reading.value === min)?.recorded_at).format("MMM DD, yyyy - hh:mm a")})
                        </td>
                    </tr>
                    <tr className="border-0 border-b border-black">
                        <th className="text-[14px] font-medium border-0 border-r border-black">
                            Max (Date - Time)
                        </th>
                        <td className="text-center">
                            {max} {rowData[0]?.unit} ({moment(rowData.find((reading: any) => reading.value === max)?.recorded_at).format("MMM DD, yyyy - hh:mm a")})
                        </td>
                    </tr>
                    <tr className="border-0 border-b border-black">
                        <th className=" text-[14px] font-medium border-0 border-r border-black">
                            Average {parameter}
                        </th>
                        <td className="text-center">
                            {mean}
                        </td>
                    </tr>
                    {/* <tr className="border-0 border-b border-black">
                        <th className="text-[14px] font-medium border-0 border-r border-black">
                            Mean Rate of Change
                        </th>
                        <td className="text-center">
                            {rateOfChange} {rowData[0]?.unit} per hour
                        </td>
                    </tr> */}
                </tbody>
            </table>
            <table className="">
                <thead className="text-[14px] font-medium border-0 border-b border-black">
                    <tr>
                        <th>
                            Date
                        </th>
                        <th>
                            Time
                        </th>
                        <th>
                            {parameter}
                        </th>
                        <th>
                            Status
                        </th>
                    </tr>
                </thead>
                <tbody>
                    {
                        rowData.map((reading: any, index: number) => <tr key={index}>
                            <td className="text-center">
                                {moment(reading?.recorded_at).format("MMM DD, yyyy")}
                            </td>
                            <td className="text-center">
                                {moment(reading?.recorded_at).format("h:mm a")}
                            </td>
                            <td className="text-center">
                                {reading?.value} {reading?.unit}
                            </td>
                            <td>
                                {
                                    threshold && threshold.length > 0 && threshold.find((thresh: any, idx: number) => {
                                        return (thresh?.type === "LT" && reading?.value < thresh.target) || (thresh?.type === "GT" && reading?.value > thresh.target) 
                                    }) ? "Poor" : "Optimal"
                                }
                            </td>
                        </tr>)
                    }
                </tbody>
            </table>
            <Signature/>
            </>}
        </div>
    </div>
}