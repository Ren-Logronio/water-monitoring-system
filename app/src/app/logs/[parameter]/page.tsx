"use client"

import ParameterDatasheet from "@/components/ParameterDatasheet";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import useFarm from "@/hooks/useFarm";
import axios from "axios";
import { notFound, useParams } from "next/navigation";
import { useEffect, useState } from "react"
import { NinetyRing } from "react-svg-spinners";

export default function Datasheet() {
    const param = useParams();
    const { selectedFarm, farmsLoading } = useFarm();

    if (!["temperature", "ph", "tds", "ammonia"].includes(param.parameter as string)) {
        notFound();
    }

    const [ponds, setPonds] = useState<any[]>([]);
    const [loading, setLoading] = useState(true);
    const [selectedPond, setSelectedPond] = useState<string>("");

    useEffect(() => {
        if (farmsLoading) return;
        axios.get(`/api/pond`).then(response => {
            if (!response.data.results || response.data.results.length <= 0) {
                setLoading(false); 
                return;
            }
            setPonds(response.data.results);
            setSelectedPond(response.data.results.filter((pond: any) => pond.farm_id === selectedFarm.farm_id)[0]?.pond_id);
            setLoading(false);
        }).catch(error => {
            console.error(error);
        });
        return () => {
            setPonds([]);
            setSelectedPond("");
        }
    }, [farmsLoading]);

    useEffect(() => {
        if(farmsLoading) return;
        setSelectedPond(ponds.filter(pond => pond.farm_id === selectedFarm.farm_id)[0]?.pond_id);
    }, [selectedFarm, farmsLoading])

    return (
        <div className="flex flex-col p-4 space-y-4">
            <div className="flex flex-row items-center space-x-4">
                {/* <p className="text-xl font-semibold m-0 p-0"></p> */}
                {
                    // !loading && ponds.length > 0 && <>
                    //     <Select value={selectedPond} onValueChange={setSelectedPond}>
                    //         <SelectTrigger className="w-[180px] border-2 border-orange-300 bg-orange-50 focus-visible:ring-blue-200/40 focus-visible:ring-4 shadow-none rounded-2xl">
                    //             <SelectValue placeholder="Select Pond" />
                    //         </SelectTrigger>
                    //         <SelectContent>
                    //             {
                    //                 ponds.map(
                    //                     (pond) => <SelectItem key={pond.pond_id} value={pond.pond_id}>{pond.name}</SelectItem>
                    //                 )
                    //             }
                    //             {/* <SelectItem value="light">Light</SelectItem> */}
                    //         </SelectContent>
                    //     </Select>
                    // </>
                }
            </div>

            {
                loading && <div className="flex flex-row justify-center space-x-2"><NinetyRing /><p>Loading Ponds...</p></div>
            }
            {
                !loading && ponds.filter(pond => pond.farm_id === selectedFarm.farm_id).length <= 0 && <p>No Ponds Found</p>
            }

            {
                !loading && selectedPond && <ParameterDatasheet pondsLoading={loading} ponds={ponds} pond_id={selectedPond} setSelectedPond={setSelectedPond} />
            }
        </div>
    )
}