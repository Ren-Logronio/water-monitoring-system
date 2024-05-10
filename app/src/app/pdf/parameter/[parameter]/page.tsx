"use client";

import { AgGridReact } from "ag-grid-react";
import axios from "axios";
import { format } from "date-fns";
import "ag-grid-community/styles/ag-grid.css";
import "ag-grid-community/styles/ag-theme-material.css";
import { useSearchParams, useRouter, useParams } from "next/navigation";
import { useEffect, useMemo, useState } from "react";

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

export default function PrintParameter() { 
    const searchParams = useSearchParams();
    const router = useRouter();
    const { parameter } = useParams();
    const [loading, setLoading] = useState(false);
    const [rowData, setRowData] = useState<any[]>([]);
    const [columnDefs, setColumnDefs] = useState<any>([
        { field: "idx", headerName: "#", lockPosition: "left", resizable: false },
        { field: "reading_id", headerName: "reading_id", lockPosition: "left", resizable: false, hide: true },
        { field: "edit_recorded_at", headerName: "edit_recorded_at", lockPosition: "left", resizable: false, hide: true },
        { field: "edit_time", headerName: "edit_time", lockPosition: "left", resizable: false, hide: true },
        { field: "reading", headerName: (parameter && `${parameter[0].toUpperCase()}${parameter.slice(1)}`) || "Reading", lockPosition: "left", resizable: false },
        { field: "date", headerName: "Date", lockPosition: "left", resizable: false },
        { field: "time", headerName: "Time", lockPosition: "left", resizable: false },
    ]);

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
                setRowData(response.data.results);
            }
        }).catch(error => {
            console.error(error);
        }).finally(() => {
            setLoading(false);
        })
    }, [pond_id]);

    return <div className="ag-theme-material max-w-full h-screen flex flex-col">
    </div>
}