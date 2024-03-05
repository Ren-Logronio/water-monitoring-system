"use client";

import { useEffect, useState } from "react";
import { Select, SelectTrigger, SelectContent, SelectItem, SelectValue } from "@/components/ui/select";
import PondView from "./PondView";
import { NinetyRing } from "react-svg-spinners";
import { Button } from "../ui/button";

import axios from "axios";
import FarmDetails from "./FarmDetails";
import { useRouter } from "next/navigation";
import PondDetails from "./PondDetails";

export default function Dashboard() {
    const router = useRouter();
    const [ponds, setPonds] = useState<{ ponds: any[], noPonds: boolean }>({ ponds: [], noPonds: false });
    const [selectedPond, setSelectedPond] = useState<string>("");
    const [farm, setFarm] = useState<any>({});
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        axios.get("/api/farm").then(response => {
            console.log("results:", response.data.results);
            if (!response.data.results || response.data.results.length <= 0) {
                setLoading(false);
                return;
            }
            setFarm(response.data.results[0]);
            if (!response.data.results[0].is_approved) {
                setLoading(false);
                return;
            }
            axios.get(`/api/farm/pond?farm_id=${response.data.results[0].farm_id}`).then(response => {
                if (!response.data.results && response.data.results.length <= 0) {
                    setPonds({ ponds: [], noPonds: true });
                } else {
                    setPonds({ ponds: response.data.results, noPonds: false });
                    setSelectedPond(response.data.results[0].device_id ? response.data.results[0].device_id : "");
                }
            }).catch(error => {
                console.error(error);
            }).finally(() => {
                setLoading(false);
            });
        }).catch(error => {
            setLoading(false);
            console.error(error);
        })
    }, []);

    useEffect(() => {
        const reloadForUpdates: any = {};
        if (farm.farm_id && !farm.is_approved) {
            reloadForUpdates.timeout = setTimeout(() => {
                router.push("/redirect?w=/dashboard");
            }, 10000);

        }
        return () => clearTimeout(reloadForUpdates.timeout);
    }, [farm])

    const handleSelectChange = (value?: string) => {
        value && setSelectedPond(value);
    };

    return (
        <div className="p-4 md:p-[24px]">
            {
                !loading ? (!farm.farm_id ? <>
                    <div className="min-w-full flex flex-col items-center">
                        <h1 className="text-center">No Farm Details</h1>
                        <FarmDetails />
                    </div>
                </>
                    : farm.farm_id && !farm.is_approved ?
                        <div className="min-w-full flex flex-col items-center">
                            <NinetyRing width={25} height={25} />
                            <h1 className="text-center">Waiting approval...</h1>
                            <p className="text-center">It seems that you have farm details but is unverified by the current owner of the farm</p>
                        </div>
                        : <>
                            {farm.farm_id && farm.is_approved && ponds.ponds.length > 0 ?
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
                                </> : <>
                                    <div className="min-w-full flex flex-col items-center">
                                        <p className="text-center">It seems that you have no pond/s for <span className=" font-[500]">{farm.name}</span>,</p>
                                        <p className="mb-8">please begin by adding the pond</p>
                                        <PondDetails farm_id={farm.farm_id} />
                                    </div>
                                </>
                            }
                        </>) : (<div className="flex flex-row justify-center items-center space-x-2">
                            <NinetyRing width={25} height={25} />
                            <p>Loading Dashboard...</p>
                        </div>)
            }
        </div>
    )
}