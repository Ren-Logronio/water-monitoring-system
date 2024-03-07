"use client";

import { useParams } from "next/navigation";
import { format } from "date-fns";
import { useState } from "react";
import { AgGridReact } from 'ag-grid-react';
import "ag-grid-community/styles/ag-grid.css";
import "ag-grid-community/styles/ag-theme-quartz.css";


const test_data = [
    {
        reading: 30, recorded_at: "2021-10-01T00:00:00Z", modified_at: "2021-10-01T00:00:00Z"
    },
    {
        reading: 35, recorded_at: "2021-10-02T00:00:00Z", modified_at: "2021-10-02T00:00:00Z"
    },
    {
        reading: 40, recorded_at: "2021-10-03T00:00:00Z", modified_at: "2021-10-03T00:00:00Z"
    },
    {
        reading: 45, recorded_at: "2021-10-04T00:00:00Z", modified_at: "2021-10-04T00:00:00Z"
    },
    {
        reading: 50, recorded_at: "2021-10-05T00:00:00Z", modified_at: "2021-10-05T00:00:00Z"
    },
];

export default function () {
    // get parameter from the url
    const params = useParams();

    const [rowData, setRowData] = useState(test_data.map((row, idx) => ({ idx, reading: row.reading, date: format(new Date(row.recorded_at), "MMM d"), time: format(new Date(row.recorded_at), "h:mm a"), actions: "[insert record, edit record, remove record]" })));
    const [columnDefs, setColumnDefs] = useState([
        { field: "idx", headerName: "#" },
        { field: "reading", headerName: "Reading" },
        { field: "date", headerName: "Date" },
        { field: "time", headerName: "Time" },
        { field: "actions", headerName: "Actions" }
    ]);


    // idx, reading, date, time, actions
    // 0, 30, Feb 19, 12:00 PM, [insert record, edit record, remove record]

    return (
        <div className="ag-theme-quartz h-[500px]">
            <AgGridReact
                rowData={rowData}
                columnDefs={columnDefs}
            />
       </div>
    );
}