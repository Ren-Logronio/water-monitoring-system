"use client";

import { useParams, usePathname, useRouter, useSearchParams } from "next/navigation";
import { format, set } from "date-fns";
import { Dispatch, SetStateAction, use, useEffect, useMemo, useRef, useState } from "react";
import { AgGridReact } from 'ag-grid-react';
import "ag-grid-community/styles/ag-grid.css";
import "ag-grid-community/styles/ag-theme-material.css";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Button } from "@/components/ui/button";
import { NinetyRing } from "react-svg-spinners";
import axios from "axios";
import { Dialog, DialogClose, DialogContent, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from "../ui/dialogNoX";
import AddReading from "./AddReading";
import { Input } from "../ui/input";
import Download from "./Download";
import Actions from "./Actions";
import { useParameterDatasheetStore } from "@/store/parameterDatasheetStore";
import { PopoverContent, PopoverTrigger, Popover } from "../ui/popover";
import DaterangePopover from "../ui/daterange";
import NumberOfItemsDropdown, { DefaultValueLabelSet } from "../ui/no-of-items-dropdown";
import moment from "moment";
import { Pagination, PaginationContent, PaginationEllipsis, PaginationItem, PaginationLink, PaginationNext, PaginationPrevious } from "../ui/pagination";
import useAuth from "@/hooks/useAuth";
import Aggregation, { DefaultAggregationValueLabelSet } from "../ui/aggregation";

const autoSizeStrategy: any = {
    type: 'fitGridWidth',
    defaultMinWidth: 100,
    columnLimits: [
        {
            colId: 'idx',
            maxWidth: 0
        },
        {
            colId: "actions",
            maxWidth: 0
        }
    ],
};

import {
    Table,
    TableBody,
    TableCaption,
    TableCell,
    TableFooter,
    TableHead,
    TableHeader,
    TableRow,
} from "@/components/ui/table";

export default function ParameterDatasheet({ pond_id, setSelectedPond, ponds, pondsLoading }: { pond_id?: string, ponds?: any[], pondsLoading: boolean, setSelectedPond: Dispatch<SetStateAction<string>> }) {
    const { user } = useAuth();
    const [selected, setSelected] = useState<string>("all");
    const [dateFrom, setDateFrom] = useState<Date>(moment.unix(0).toDate());
    const [dateTo, setDateTo] = useState<Date>(moment().toDate());
    const [thresholds, setThresholds] = useState<any>([]);
    const [aggregation, setAggregation] = useState<string>("4");
    const searchParams = useSearchParams();
    const params = useParams();
    const router = useRouter();
    const pathname = usePathname();
    const { rowData, setRowData, purgeRowData } = useParameterDatasheetStore();
    const inputFile = useRef<HTMLInputElement | null>(null);
    const [loading, setLoading] = useState(true);
    const [columnDefs, setColumnDefs] = useState<any>([
        { field: "idx", headerName: "#", lockPosition: "left", resizable: false },
        { field: "reading_id", headerName: "reading_id", lockPosition: "left", resizable: false, hide: true },
        { field: "edit_recorded_at", headerName: "edit_recorded_at", lockPosition: "left", resizable: false, hide: true },
        { field: "edit_time", headerName: "edit_time", lockPosition: "left", resizable: false, hide: true },
        { field: "date", headerName: "Date", lockPosition: "left", resizable: false },
        { field: "time", headerName: "Time", lockPosition: "left", resizable: false },
        { field: "reading", headerName: (params.parameter && `${params.parameter[0].toUpperCase()}${params.parameter.slice(1)}`) || "Reading", lockPosition: "left", resizable: false },
        // { field: "recorded_by", headerName: "Recorded By", lockPosition: "left", resizable: false },
        // { headerName: "Actions", lockPosition: "right", cellRenderer: Actions, valueGetter: (params: any) => ({ reading_id: params.data.reading_id, reading: params.data.reading, date: params.data.edit_recorded_at, time: params.data.edit_time }), resizable: false }
    ]);

    const [currentPage, setCurrentPage] = useState(1);

    const numberOfPages = useMemo(() => {
        const items = searchParams.get("items") === "all" ? 99999 : parseInt(searchParams.get("items") || "25");
        return Math.ceil(rowData.length / items);
    }, [rowData, searchParams.get("items")])

    const filteredDate = useMemo(() => {
        const filterDateRange = rowData.filter((row: any) => {
            const date = moment(row.edit_recorded_at);
            return date.isBetween(dateFrom, dateTo, "day", "[]");
        });
        console.log("filteredDate:", filterDateRange);
        return filterDateRange;
    }, [rowData, dateFrom, dateTo, selected]);

    const paginatedItems = useMemo(() => {
        const items = searchParams.get("items") === "all" ? 99999 : parseInt(searchParams.get("items") || "25");
        return filteredDate.slice((currentPage - 1) * items, currentPage * items);
    }, [filteredDate, searchParams.get("items"), currentPage]); 

    useEffect(() => {
        !loading && setLoading(true);
        purgeRowData();
        axios.get(`/api/pond/parameter/reading?pond_id=${pond_id}&parameter=${params.parameter}`).then(response => {
            if (response.data.results && response.data.results.length > 0) {
                console.log("response.data.results:", response.data.results);
                setRowData(response.data.results
                    .sort((a: any, b: any) => b.reading_id - a.reading_id)
                    .map((row: any, idx: number) => ({ 
                        idx: idx + 1, 
                        reading_id: row.reading_id, 
                        edit_recorded_at: format(row.recorded_at, "yyyy-MM-dd"), 
                        edit_time: format(row.recorded_at, "hh:mm"), 
                        reading: `${row.value} ${row.unit}`, 
                        date: format(new Date(row.recorded_at), "MMM dd, yyyy"), 
                        time: format(new Date(row.recorded_at), "h:mm a"), 
                        recorded_at: row.recorded_at,
                        value: row.value,
                        // recorded_by: row.isRecordedBySensor ? "sensor" : "farmer" 
                    })
                    )
                );
            }
            axios.get(`/api/threshold?parameter=${params.parameter}`).then(response => {
                if (response.data.results && response.data.results.length > 0) {
                    setThresholds(response.data.results);
                }
            }).catch(error => {
                console.error(error);
            }).finally(() => {
                setLoading(false);
            });
        }).catch(error => {
            console.error(error);
        });
    }, [pond_id]);

    const handleFileImportPress = () => {
        inputFile.current?.click();
    };

    return (
        <>
            {/* while loading */}
            {loading &&
                <div className="flex flex-row justify-center items-center space-x-2">
                    <NinetyRing />
                    <p>Loading {params.parameter} readings..</p>
                </div>
            }

            {
                !loading && <>
                    <div className="flex flex-row items-center justify-between">
                        <div className="flex flex-row items-center space-x-4">
                            {
                                !loading && !!ponds && ponds.length > 0 && <>
                                    <Select value={pond_id} onValueChange={setSelectedPond}>
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
                                </>
                            }
                            { thresholds 
                            && thresholds.length && 
                            <p className="text-[14px] italic">Optimal {params.parameter && `${params.parameter[0].toUpperCase()}${params.parameter.slice(1)}`} levels: {
                                [
                                    thresholds.find((thresholds: any) => thresholds.type === "LT"), 
                                    thresholds.find((thresholds: any) => thresholds.type === "GT")
                                ].map(thresholds => `${thresholds.target}`).join(" to ")
                                // unit
                                
                            }</p>}
                            {/* <AddReading pond_id={pond_id} /> */}
                            {/* <Button variant="outline" onClick={handleFileImportPress} className="flex flex-row space-x-2">
                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" className="w-5 h-5">
                                    <path d="M9.25 13.25a.75.75 0 0 0 1.5 0V4.636l2.955 3.129a.75.75 0 0 0 1.09-1.03l-4.25-4.5a.75.75 0 0 0-1.09 0l-4.25 4.5a.75.75 0 1 0 1.09 1.03L9.25 4.636v8.614Z" />
                                    <path d="M3.5 12.75a.75.75 0 0 0-1.5 0v2.5A2.75 2.75 0 0 0 4.75 18h10.5A2.75 2.75 0 0 0 18 15.25v-2.5a.75.75 0 0 0-1.5 0v2.5c0 .69-.56 1.25-1.25 1.25H4.75c-.69 0-1.25-.56-1.25-1.25v-2.5Z" />
                                </svg>
                                <p>Import file</p>
                            </Button> */}
                            {/* <Input type="file" ref={inputFile} accept=".csv" className="hidden" /> */}
                        </div>
                        <div className="flex flex-row space-x-2 text-[14px]">
                            {/* <Button className="flex flex-row space-x-2" variant="outline">
                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" className="w-5 h-5">
                                    <path fillRule="evenodd" d="M5 2.75C5 1.784 5.784 1 6.75 1h6.5c.966 0 1.75.784 1.75 1.75v3.552c.377.046.752.097 1.126.153A2.212 2.212 0 0 1 18 8.653v4.097A2.25 2.25 0 0 1 15.75 15h-.241l.305 1.984A1.75 1.75 0 0 1 14.084 19H5.915a1.75 1.75 0 0 1-1.73-2.016L4.492 15H4.25A2.25 2.25 0 0 1 2 12.75V8.653c0-1.082.775-2.034 1.874-2.198.374-.056.75-.107 1.127-.153L5 6.25v-3.5Zm8.5 3.397a41.533 41.533 0 0 0-7 0V2.75a.25.25 0 0 1 .25-.25h6.5a.25.25 0 0 1 .25.25v3.397ZM6.608 12.5a.25.25 0 0 0-.247.212l-.693 4.5a.25.25 0 0 0 .247.288h8.17a.25.25 0 0 0 .246-.288l-.692-4.5a.25.25 0 0 0-.247-.212H6.608Z" clipRule="evenodd" />
                                </svg>
                                <p>Print View</p>
                            </Button> */}
                            <div className="flex flex-row items-center space-x-2 relative">
                                <NumberOfItemsDropdown 
                                    setValueLabel={DefaultValueLabelSet} 
                                    defaultValue={searchParams.get("items") || "25"}
                                    onValueChange={(value) => {
                                        setCurrentPage(1);
                                        router.push(`${pathname}?items=${value}`);
                                    }} />
                            </div>
                            <div className="flex flex-row items-center space-x-2 relative">
                                <DaterangePopover onChange={(dateFrom, dateTo, mode) => {
                                    setDateFrom(dateFrom);
                                    setDateTo(dateTo);
                                    setSelected(mode);
                                }}/>
                            </div>
                            <Aggregation setValueLabel={DefaultAggregationValueLabelSet} defaultValue="minute" onValueChange={() => {
                                setCurrentPage(1);
                                setAggregation(aggregation);
                            }} />
                            <Download pond_id={pond_id} />
                        </div>
                    </div>
                    <div className="ag-theme-material h-[calc(100vh-200px)]">
                        <span className="!bg-red-100 hidden">This is here to persist the !bg-red-100 style</span>
                        <span className="!bg-yellow-50 hidden">This is here to persist the !bg-yellow-50 style</span>
                        <AgGridReact getRowClass={(params: any): any => {
                            let resultingStyle = "";
                            thresholds.forEach((threshold: any) => {
                                if (threshold.type === "LT") {
                                    if (params.data.value < threshold.target) {
                                        if (threshold.action === "WARN") {
                                            resultingStyle = "!bg-yellow-50";
                                        }
                                        if (threshold.action === "ALRT") {
                                            resultingStyle = "!bg-red-100";
                                        }
                                    }
                                } else if (threshold.type === "GT") {
                                    if (params.data.value > threshold.target) {
                                        if (threshold.action === "WARN") {
                                            resultingStyle = "!bg-yellow-50";
                                        }
                                        if (threshold.action === "ALRT") {
                                            resultingStyle = "!bg-red-100";
                                        }
                                    }
                                }
                            });
                            return resultingStyle;
                        }} rowData={paginatedItems} columnDefs={columnDefs} autoSizeStrategy={autoSizeStrategy} /> 
                        { !!numberOfPages && numberOfPages !== 1 && <Pagination className="mt-2">
                            <PaginationContent>
                                {currentPage > 1 && <PaginationItem>
                                    <PaginationPrevious className=" cursor-pointer" onClick={ () => setCurrentPage(prev => prev - 1)} />
                                </PaginationItem>}
                                {
                                    Array.from({ length: numberOfPages }, (_, idx) => idx + 1).map((page) => {
                                        return <>{
                                        (page === currentPage || (page < (currentPage + 3) && page > (currentPage - 3))) && <PaginationItem key={page}>
                                            <PaginationLink className=" cursor-pointer" onClick={() => { setCurrentPage(page) }} isActive={currentPage === page}>
                                                {page}
                                            </PaginationLink>
                                        </PaginationItem>
                                        }</>
                                    })
                                }
                                {!(currentPage > (numberOfPages - 1)) && <PaginationItem>
                                <PaginationNext className=" cursor-pointer" onClick={ () => setCurrentPage(prev => prev + 1) } />
                                </PaginationItem>}
                            </PaginationContent>
                        </Pagination>}
                    </div>
                </>
            }
        </>
    );
}