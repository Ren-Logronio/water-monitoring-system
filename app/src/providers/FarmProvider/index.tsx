"use client";

import FarmDetails from "@/components/ui/dialog/AddFarm.dialog";
import useAuth from "@/hooks/useAuth";
import axios from "axios";
import { createContext, useEffect, useState } from "react";

export const FarmContext = createContext<any>({});

export default function FarmProvider({ children }: Readonly<{ children: React.ReactNode }>) {
    const [farms, setFarm] = useState<any[]>([]);
    const [selectedFarm, setSelectedFarm] = useState({} as any);
    const [farmsLoading, setFarmsLoading] = useState(true);

    const { addEventListener, removeEventListener } = useAuth();

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
        const signInListener = addEventListener("signin", () => {
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
        });
        const signOutListener = addEventListener("signout", () => {
            setFarm([]);
            setSelectedFarm({});
        });
        return () => {
            removeEventListener(signInListener);
            removeEventListener(signOutListener);
        };
    }, []);

    const appendFarm = (farm: any) => {
        setFarm((prev: any) => [...prev, farm]);
    };

    return <FarmContext.Provider value={{farms, selectedFarm, setSelectedFarm, appendFarm, farmsLoading}}>
        {children}
    </FarmContext.Provider>;
}