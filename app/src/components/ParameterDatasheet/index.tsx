"use client";

import { useParams } from "next/navigation";
import { format } from "date-fns";
import { useEffect, useState } from "react";
import { AgGridReact } from 'ag-grid-react';
import "ag-grid-community/styles/ag-grid.css";
import "ag-grid-community/styles/ag-theme-quartz.css";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Button } from "@/components/ui/button";
import { NinetyRing } from "react-svg-spinners";
import axios from "axios";

const autoSizeStrategy = {
    type: 'fitGridWidth',
    defaultMinWidth: 100,
    columnLimits: [
        {
            colId: 'country',
            minWidth: 900
        }
    ]
};

const actions = (props: any) => {

    const handleEdit = () => {
        console.log("Edit IDX:", props.getValue());
    }

    return (
        <div className="flex flex-row space-x-2">
            <Button onClick={handleEdit}>Edit</Button>
            <Button>Delete</Button>
        </div>
    );

}

export default function ({ pond_id }: { pond_id?: string }) {
    // get parameter from the url
    const params = useParams();
    const [loading, setLoading] = useState(true);
    const [rowData, setRowData] = useState([]);
    const [columnDefs, setColumnDefs] = useState([
        { field: "idx", headerName: "#", lockPosition: "left", resizable: false },
        { field: "reading", headerName: "Reading", lockPosition: "left", resizable: false },
        { field: "date", headerName: "Date", lockPosition: "left", resizable: false },
        { field: "time", headerName: "Time", lockPosition: "left", resizable: false },
        { field: "recorded_by", headerName: "Recorded By", lockPosition: "left", resizable: false },
        { headerName: "Actions", lockPosition: "right", cellRenderer: actions, valueGetter: (params: any) => ({ idx: params.data.idx, reading: params.data.reading, date: params.data.date, time: params.data.time, recorded_by: params.data.recorded_by }), resizable: false }
    ]);

    useEffect(() => {
        !loading && setLoading(true);
        axios.get(`/api/pond/parameter/reading?pond_id=${pond_id}&parameter=${params.parameter}`).then(response => {
            if (response.data.results && response.data.results.length > 0) {
                console.log("response.data.results:", response.data.results);
                setRowData(response.data.results.sort((a: any, b: any) => b.reading_id - a.reading_id).map((row: any, idx: number) => ({ idx, reading: row.value, date: format(new Date(row.recorded_at), "MMM d"), time: format(new Date(row.recorded_at), "h:mm a"), recorded_by: row.isRecordedBySensor ? "sensor" : "farmer" })));
            }
            console.log("response.data.results:", response.data.results);
        }).catch(error => {
            console.error(error);
        }).finally(() => {
            setLoading(false);
        })
    }, [pond_id]);

    useEffect(() => {
        console.log("rowData:", rowData);
    }, [rowData])

    return (
        <>
            {
                loading && <div className="flex flex-row justify-center items-center space-x-2"><NinetyRing /><p>Loading {params.parameter} readings..</p></div>
            }
            {
                !loading && <><div className="flex flex-row items-center justify-between">
                    <div className="flex flex-row items-center space-x-2">
                        <Button>Add</Button>
                        <Button variant="outline">Import file</Button>
                    </div>
                    <div className="flex flex-row space-x-2">
                        <Button variant="outline">Print View</Button>
                        <Button variant="outline">Download</Button>
                    </div>
                </div>
                    <div className="ag-theme-quartz h-[calc(100vh-200px)]">
                        {/* eslint-disable-next-line */}
                        <AgGridReact rowData={rowData} columnDefs={columnDefs} autoSizeStrategy={autoSizeStrategy} />
                    </div></>
            }
        </>
    );
}