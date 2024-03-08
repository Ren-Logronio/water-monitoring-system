"use client";

import { useParams } from "next/navigation";
import { format } from "date-fns";
import { useState } from "react";
import { AgGridReact } from 'ag-grid-react';
import "ag-grid-community/styles/ag-grid.css";
import "ag-grid-community/styles/ag-theme-quartz.css";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Button } from "@/components/ui/button";


const test_data = [
    {
        reading: 30, recorded_at: "2021-10-01T00:00:00Z", modified_at: "2021-10-01T00:00:00Z", sensor: false
    },
    {
        reading: 35, recorded_at: "2021-10-02T00:00:00Z", modified_at: "2021-10-02T00:00:00Z", sensor: true
    },
    {
        reading: 40, recorded_at: "2021-10-03T00:00:00Z", modified_at: "2021-10-03T00:00:00Z", sensor: true
    },
    {
        reading: 45, recorded_at: "2021-10-04T00:00:00Z", modified_at: "2021-10-04T00:00:00Z", sensor: true
    },
    {
        reading: 50, recorded_at: "2021-10-05T00:00:00Z", modified_at: "2021-10-05T00:00:00Z", sensor: true
    },
    {
        reading: 55, recorded_at: "2021-10-06T00:00:00Z", modified_at: "2021-10-06T00:00:00Z", sensor: true
    },
    {
        reading: 60, recorded_at: "2021-10-07T00:00:00Z", modified_at: "2021-10-07T00:00:00Z", sensor: true
    },
    {
        reading: 65, recorded_at: "2021-10-08T00:00:00Z", modified_at: "2021-10-08T00:00:00Z", sensor: true
    },
    {
        reading: 70, recorded_at: "2021-10-09T00:00:00Z", modified_at: "2021-10-09T00:00:00Z", sensor: true
    },
    {
        reading: 75, recorded_at: "2021-10-10T00:00:00Z", modified_at: "2021-10-10T00:00:00Z", sensor: true
    },
    {
        reading: 80, recorded_at: "2021-10-11T00:00:00Z", modified_at: "2021-10-11T00:00:00Z", sensor: true
    },
    {
        reading: 85, recorded_at: "2021-10-12T00:00:00Z", modified_at: "2021-10-12T00:00:00Z", sensor: true
    },
    {
        reading: 90, recorded_at: "2021-10-13T00:00:00Z", modified_at: "2021-10-13T00:00:00Z", sensor: true
    },
    {
        reading: 95, recorded_at: "2021-10-14T00:00:00Z", modified_at: "2021-10-14T00:00:00Z", sensor: true
    },
];

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

export default function () {
    // get parameter from the url
    const params = useParams();
    const [sortSelection, setSortSelection] = useState("date");
    const [rowData, setRowData] = useState(test_data.map((row, idx) => ({ idx, reading: row.reading, date: format(new Date(row.recorded_at), "MMM d"), time: format(new Date(row.recorded_at), "h:mm a"), recorded_by: row.sensor ? "sensor" : "farmer", actions: "[insert record, edit record, remove record]" })));
    const [columnDefs, setColumnDefs] = useState([
        { field: "idx", headerName: "#", lockPosition: "left", resizable: false },
        { field: "reading", headerName: "Reading", lockPosition: "left", resizable: false },
        { field: "date", headerName: "Date", lockPosition: "left", resizable: false },
        { field: "time", headerName: "Time", lockPosition: "left", resizable: false },
        { field: "recorded_by", headerName: "Recorded By", lockPosition: "left", resizable: false },
        { headerName: "Actions", lockPosition: "right", cellRenderer: actions, valueGetter: (params: any) => ({ idx: params.data.idx, reading: params.data.reading, date: params.data.date, time: params.data.time, recorded_by: params.data.recorded_by }), resizable: false }
    ]);

    return (
        <div className="flex flex-col p-4 space-y-4">
            <p className="text-xl font-semibold m-0 p-0">Datasheet</p>
            <div className="flex flex-row items-center justify-between">
                <div className="flex flex-row items-center space-x-2">
                    <Button>Add</Button>
                    <Button>Import file</Button>
                </div>
                <div className="flex flex-row space-x-2">
                    <Button>Print View</Button>
                    <Button>Download</Button>
                </div>
            </div>
            <div className="ag-theme-quartz h-[calc(100vh-54px-16px-16px-58px)]">
                {/* eslint-disable-next-line */}
                <AgGridReact rowData={rowData} columnDefs={columnDefs} autoSizeStrategy={autoSizeStrategy} />
            </div>
        </div>
    );
}