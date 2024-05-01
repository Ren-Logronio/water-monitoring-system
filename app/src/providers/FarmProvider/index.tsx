"use client";

import axios from "axios";
import { createContext, useEffect, useState } from "react";

export const FarmContext = createContext<any>({});

export default function FarmProvider({ children }: Readonly<{ children: React.ReactNode }>) {
    const [farms, setFarm] = useState([]);
    const [selectedFarm, setSelectedFarm] = useState({} as any);
    const [farmsLoading, setFarmsLoading] = useState(true);

    useEffect(() => {
        axios.get("/api/farm").then(response => {
            if (!response.data.results || response.data.results.length <= 0) {
                setFarm([]);
                return;
            }
            setFarm(response.data.results);
                setSelectedFarm(response.data.results[0]);
        }).catch(error => {
            console.error(error);
        }).finally(() => {
            setFarmsLoading(false);
        });
    }, []);

    return <FarmContext.Provider value={{farms, selectedFarm, setSelectedFarm, farmsLoading}}>
        {children}
    </FarmContext.Provider>;
}