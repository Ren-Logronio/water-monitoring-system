"use client";

import { useEffect, useState } from "react";
import { Select, SelectTrigger, SelectContent, SelectItem, SelectValue } from "@/components/ui/select";
import PondView from "./PondView";
import { NinetyRing } from "react-svg-spinners";
import { Button } from "../ui/button";
import axios from "axios";

export default function Dashboard() {
    const [ ponds, setPonds ] = useState<{ponds: any[], noPonds: boolean}>({ ponds: [], noPonds: false});
    const [ selectedPond, setSelectedPond ] = useState<string>("");
    const [ noFarm, setNoFarm ] = useState(true);
    const [ loading, setLoading ] = useState(true);

    useEffect(() => {
        const response = axios.get("/api/farm").then(response => {
            if (!response.data.results || response.data.results.length <= 0) {
                setNoFarm(true);
                setLoading(false);
                return;
            } 
            axios.get("/api/pond").then(response => {
                if(!response.data.results && response.data.results.length <= 0) {
                    setPonds({ ponds: [], noPonds: true });
                } else {
                    setPonds({ ponds: response.data.results, noPonds: false });
                    setSelectedPond(response.data.results[0].device_id);
                }
            }).catch(error => {
                console.error(error);
            }).finally(() => {
                setLoading(false);
            });
            setNoFarm(false);
        }).catch(error => {
            setLoading(false);
            console.error(error);
        })
    }, []);

    useEffect(() => {
        console.log(ponds);
    }, [ponds])

    const handleSelectChange = (value?: string) => {
        value && setSelectedPond(value);
    };
    
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
                            <Select value={selectedPond} onValueChange={handleSelectChange}>
                                <SelectTrigger className="w-[180px] bg-white">
                                    <SelectValue placeholder="Select Pond" />
                                </SelectTrigger>
                                <SelectContent>
                                    {
                                        ponds?.ponds.map(
                                            (pond) => <SelectItem key={pond.device_id} value={pond.device_id}>{pond.name}</SelectItem>
                                        )
                                    }
                                    {/* <SelectItem value="light">Light</SelectItem> */}
                                </SelectContent>
                            </Select>
                            <PondView device_id={selectedPond} />
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