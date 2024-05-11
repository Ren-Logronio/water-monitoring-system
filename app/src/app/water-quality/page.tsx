"use client";

import { Button } from "@/components/ui/button";
import DaterangePopover from "@/components/ui/daterange";
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger } from "@/components/ui/dropdown-menu";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import {
    Table,
    TableBody,
    TableCaption,
    TableCell,
    TableHead,
    TableHeader,
    TableRow,
} from "@/components/ui/table"
import useFarm from "@/hooks/useFarm";
import roundToSecondDecimal from "@/utils/RoundToNDecimals";
import axios from "axios";
import moment from "moment";
import Link from "next/link";
import { useEffect, useMemo, useState } from "react";
import { NinetyRing } from "react-svg-spinners";

export default function WaterQuality() {
    const { selectedFarm, farmsLoading } = useFarm();
    const [selected, setSelected] = useState<string>("all");
    const [dateFrom, setDateFrom] = useState<Date>(moment.unix(0).toDate());
    const [dateTo, setDateTo] = useState<Date>(moment().toDate());
    const [ponds, setPonds] = useState<any[]>([]);
    const [loading, setLoading] = useState(true);
    const [selectedPond, setSelectedPond] = useState<string>("");
    const [waterQualityReadings, setWaterQualityReadings] = useState<any[]>([]);

    useEffect(() => {
        if (farmsLoading) return;
        axios.get(`/api/pond`).then(response => {
            if (!response.data.results || response.data.results.length <= 0) {
                setLoading(false); 
                return;
            }
            setPonds(response.data.results);
            setSelectedPond(response.data.results.filter((pond: any) => pond.farm_id === selectedFarm.farm_id)[0]?.pond_id);
            axios.get(`/api/water-quality?pond_id=${response.data.results.filter((pond: any) => pond.farm_id === selectedFarm.farm_id)[0]?.pond_id}`).then(response => {
                setWaterQualityReadings(response.data.results.filter((result: any) => moment(result.timestamp).isBetween(moment(dateFrom), moment(dateTo).add(1, "hour"), "hour")));
            }).catch(error => {
                console.error(error);
            }).finally(() => {
                setLoading(false);
            });
        }).catch(error => {
            console.error(error);
        });
        return () => {
            setPonds([]);
            setSelectedPond("");
        }
    }, [farmsLoading]);

    useEffect(() => {
        if(!selectedPond) return;
        setLoading(true);
        axios.get(`/api/water-quality?pond_id=${selectedPond}`).then(response => {
            setWaterQualityReadings(response.data.results.filter((result: any) => moment(result.timestamp).isBetween(moment(dateFrom), moment(dateTo).add(1, "hour"), "hour")));
        }).catch(error => {
            console.error(error);
        }).finally(() => {
            setLoading(false);
        });
    }, [selectedPond])

    useEffect(() => {
        if(farmsLoading) return;
        setSelectedPond(ponds.filter(pond => pond.farm_id === selectedFarm.farm_id)[0]?.pond_id);
    }, [selectedFarm, farmsLoading]);

    useEffect(() => {
        console.log("WATER QUALITY READINGS", waterQualityReadings);
    }, [waterQualityReadings])

    const handleDownload = (format: string) => {
        return () => {
            if (format === "csv") {
                let csvString = "";
                // Date, Time, Avg. Temperature, Avg. pH, Avg. TDS, Avg. Ammonia, Water Quality
                csvString += "Date,Time,Avg. Temperature,Avg. pH,Avg. TDS,Avg. Ammonia,Water Quality\n";
                waterQualityReadingsFilteredByDate.forEach((reading, index) => {
                    csvString += `${moment(reading.timestamp).format("MMM DD YYYY")},${moment(reading.timestamp).format("hh:mm A")},${reading.temperature} °C,${reading.ph},${reading.tds} ppm,${reading.ammonia},${roundToSecondDecimal(reading.wqi * 100)}% (${reading.classification})\n`;
                });
                const blob = new Blob([csvString], { type: 'text/csv' });
                const url = window.URL.createObjectURL(blob);
                const link = document.createElement('a');
                link.href = url;
                link.setAttribute('download', `Water_Quality_Report-${moment().format("MMM-DD-yyyy_h:mm-a")}.csv`);
                document.body.appendChild(link);
                link.click();
                link?.parentNode?.removeChild(link);
                window.URL.revokeObjectURL(url);
            }
        }
    };

    const waterQualityReadingsFilteredByDate = useMemo(() => {
        return waterQualityReadings.filter((result: any) => moment(result.timestamp).isBetween(moment(dateFrom), moment(dateTo).add(1, "hour"), "hour"));
    }, [waterQualityReadings, dateFrom, dateTo])

    return (
        <div className="p-4">
            {loading && <div className="flex justify-center items-center h-40 space-x-2">
                    <NinetyRing/>
                    <span>Please Wait...</span>
                </div>}
            {!loading && <>
            <div className="flex flex-row justify-between">
                <Select value={selectedPond} onValueChange={setSelectedPond}>
                    <SelectTrigger className="w-[180px] border-2 border-orange-300 bg-orange-50 focus-visible:ring-blue-200/40 focus-visible:ring-4 shadow-none rounded-2xl">
                        <SelectValue placeholder="Select Pond" />
                    </SelectTrigger>
                    <SelectContent>
                        {
                            ponds.map(
                                (pond) => <SelectItem key={pond.pond_id} value={pond.pond_id}>{pond.name}</SelectItem>
                            )
                        }
                        {/* <SelectItem value="light">Light</SelectItem> */}
                    </SelectContent>
                </Select>
                <div className="flex flex-row space-x-2">
                    <DaterangePopover onChange={(dateFrom, dateTo, mode) => {
                        setDateFrom(dateFrom);
                        setDateTo(dateTo);
                        setSelected(mode);
                    }}/>
                    <DropdownMenu>
                        <DropdownMenuTrigger disabled={loading || !waterQualityReadingsFilteredByDate.length} asChild>
                            <Button variant="outline" className="flex flex-row space-x-2">
                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" className="w-5 h-5">
                                    <path fillRule="evenodd" d="M4.5 2A1.5 1.5 0 0 0 3 3.5v13A1.5 1.5 0 0 0 4.5 18h11a1.5 1.5 0 0 0 1.5-1.5V7.621a1.5 1.5 0 0 0-.44-1.06l-4.12-4.122A1.5 1.5 0 0 0 11.378 2H4.5Zm4.75 6.75a.75.75 0 0 1 1.5 0v2.546l.943-1.048a.75.75 0 0 1 1.114 1.004l-2.25 2.5a.75.75 0 0 1-1.114 0l-2.25-2.5a.75.75 0 1 1 1.114-1.004l.943 1.048V8.75Z" clipRule="evenodd" />
                                </svg>
                                <p>{loading ? "Downloading.." : "Download"}</p>
                            </Button>
                        </DropdownMenuTrigger>
                        <DropdownMenuContent className="w-56 mr-4">
                            <DropdownMenuItem onClick={handleDownload("csv")} className=" cursor-pointer">CSV</DropdownMenuItem>
                            <DropdownMenuItem className=" cursor-pointer">
                                <Link rel="noopener noreferrer" href={`/pdf/water-quality?pond_id=${selectedPond}&from=${moment(dateFrom).toDate().toISOString()}&to=${moment(dateTo).toDate().toISOString()}`} target="_blank" className="w-full text-start">
                                    PDF
                                </Link>
                            </DropdownMenuItem>
                        </DropdownMenuContent>
                    </DropdownMenu>
                </div>
            </div>
            <Table className="mt-2">
                <TableHeader>
                    <TableRow>
                        <TableHead>#</TableHead>
                        <TableHead>Date</TableHead>
                        <TableHead>Time</TableHead>
                        <TableHead>Avg. Temperature</TableHead>
                        <TableHead>Avg. pH</TableHead>
                        <TableHead>Avg. TDS</TableHead>
                        <TableHead>Avg. Ammonia</TableHead>
                        <TableHead>Water Quality</TableHead>
                    </TableRow>
                </TableHeader>
                <TableBody>
                    {
                        !!waterQualityReadingsFilteredByDate?.length && waterQualityReadingsFilteredByDate.map((reading, index) => (
                            <TableRow key={index}>
                                <TableCell>{index + 1}</TableCell>
                                <TableCell>{moment(reading.timestamp).format("MMM DD, YYYY")}</TableCell>
                                <TableCell>{moment(reading.timestamp).format("hh:mm A")}</TableCell>
                                <TableCell>{reading.temperature} °C</TableCell>
                                <TableCell>{reading.ph}</TableCell>
                                <TableCell>{reading.tds} ppm</TableCell>
                                <TableCell>{reading.ammonia} ppm</TableCell>
                                <TableCell>{roundToSecondDecimal(reading.wqi * 100)}% ({reading.classification})</TableCell>
                            </TableRow>
                        ))
                    }
                    {
                        !waterQualityReadingsFilteredByDate?.length && <TableRow>
                            <TableCell colSpan={8} className="text-center">No readings found.</TableCell>
                        </TableRow>
                    }
                    {/* <TableRow>
                        <TableCell className="font-medium">INV001</TableCell>
                        <TableCell>Paid</TableCell>
                        <TableCell>Credit Card</TableCell>
                        <TableCell className="text-right">$250.00</TableCell>
                    </TableRow> */}
                </TableBody>
            </Table>
            
            </>}
        </div>
    )
}