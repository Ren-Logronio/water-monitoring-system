"use client"

import ParameterDatasheet from "@/components/ParameterDatasheet";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import axios from "axios";
import { notFound, useParams } from "next/navigation";
import { useEffect, useState } from "react"
import { NinetyRing } from "react-svg-spinners";

export default function Datasheet() {
    const param = useParams();

    if (!["temperature", "ph", "do", "salinity", "ammonia"].includes(param.parameter as string)) {
        notFound();
    }

    const [ponds, setPonds] = useState<any[]>([]);
    const [loading, setLoading] = useState(true);
    const [selectedPond, setSelectedPond] = useState<string>("");

    useEffect(() => {
        axios.get("/api/pond").then(response => {
            if (!response.data.results || response.data.results.length <= 0) {
                setLoading(false);
                return;
            }
            setPonds(response.data.results);
            setSelectedPond(response.data.results[0].pond_id);
            setLoading(false);
        }).catch(error => {
            console.error(error);
        })
    }, [])

    return (
        <div className="flex flex-col p-4 space-y-4">
            <div className="flex flex-row items-center space-x-4">
                <p className="text-xl font-semibold m-0 p-0">Datasheet</p>
                {
                    !loading && ponds.length > 0 && <>
                        <Select value={selectedPond} onValueChange={setSelectedPond}>
                            <SelectTrigger className="w-[180px] bg-white">
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
            </div>
            {
                loading && <div className="flex flex-row justify-center space-x-2"><NinetyRing /><p>Loading Ponds...</p></div>
            }
            {
                !loading && ponds.length <= 0 && <p>No Ponds Found</p>
            }
            {
                !loading && !selectedPond && <p>No Pond Selected</p>
            }
            {
                !loading && selectedPond && <ParameterDatasheet pond_id={selectedPond} />
            }
        </div>
    )
}