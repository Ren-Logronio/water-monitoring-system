"use client";

import { useEffect, useState } from "react";
import { Select, SelectTrigger, SelectContent, SelectItem, SelectValue } from "@/components/ui/select";
import PondView from "./PondView";
import { NinetyRing } from "react-svg-spinners";
import { Button } from "../ui/button";
import axios from "axios";

export default function Dashboard() {
    const [ ponds, setPonds ] = useState({ ponds: [], noPonds: false});
    const [ noFarm, setNoFarm ] = useState(true);
    const [ loading, setLoading ] = useState(true);

    useEffect(() => {
        const response = axios.get("/api/farm").then(response => {
            if (!response.data.results || response.data.results.length <= 0) {
                setNoFarm(true);
                return;
            } 
            setNoFarm(false);
        }).catch(error => {
            console.error(error);
        }).finally(() => {
            setLoading(false);
        });

    }, []);
    
    return (
        <div className="p-4">
            {
                !loading ? (noFarm ? <>
                    <div className="min-w-full flex flex-col items-center">
                        <h1 className="text-center">No Farm Details</h1>
                        <Button variant="outline">Enter Farm Details</Button>
                    </div>
                </> : <>
                    { ponds.ponds.length > 0 ?
                        <>
                            <Select>
                                <SelectTrigger className="w-[180px] bg-white">
                                    <SelectValue placeholder="Theme" />
                                </SelectTrigger>
                                <SelectContent>
                                    <SelectItem value="light">Light</SelectItem>
                                    <SelectItem value="dark">Dark</SelectItem>
                                    <SelectItem value="system">System</SelectItem>
                                </SelectContent>
                            </Select>
                            <PondView />
                        </> :  <>
                            <div className="min-w-full flex flex-col items-center">
                                <h1 className="text-center">No Pond Details</h1>
                                <Button variant="outline">Enter Pond Details</Button>
                            </div>
                        </>
                    }
                </>) : (<div className="flex flex-row justify-center items-center space-x-2">
                    <NinetyRing width={25} height={25}/>
                    <p>Loading Dashboard...</p>
                </div>)
            }
        </div>
    )
}