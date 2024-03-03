"use client";

import { useEffect, useState } from "react";
import PondView from "./PondView";

export default function Dashboard() {
    const [ ponds, setPonds ] = useState([]);

    useEffect(() => {
        
    }, []);
    
    return (
        <div>
            <h1>Dashboard</h1>
            <p>This is the dashboard page</p>
            <PondView />
        </div>
    )
}