"use client";

import { useEffect, useState } from "react";
import { Select, SelectTrigger, SelectContent, SelectItem, SelectValue } from "@/components/ui/select";
import PondView from "./PondView";
import { NinetyRing } from "react-svg-spinners";

import axios from "axios";
import FarmDetails from "./FarmDetails";
import { useRouter } from "next/navigation";

import AddPondDialog from "../ui/dialog/AddPond.dialog";

export default function Dashboard() {
    const router = useRouter();
    const [ponds, setPonds] = useState<{ ponds: any[], noPonds: boolean }>({ ponds: [], noPonds: false });
    const [selectedPond, setSelectedPond] = useState<string>("");
    const [farm, setFarm] = useState<any>({});
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        axios.get("/api/farm").then(response => {
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
                    setSelectedPond(response.data.results[0] && response.data.results[0].pond_id ? response.data.results[0].pond_id : "");
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
    }, [farm, router])

    useEffect(() => {
        console.log("selectedPond:", selectedPond);
    }, [selectedPond]);

    const handleSelectChange = (value?: string) => {
        value && setSelectedPond(value);
    };

    return (
        <div className="p-4 md:p-[24px] h-screen">

            {/* loading spinner */}
            {loading &&
                <div className="flex flex-row justify-center items-center space-x-2 mt-10">
                    <NinetyRing width={40} height={40} />

                </div>
            }

            {/* No Farm Details */}
            {!loading && !farm.farm_id &&
                <div className="min-w-full flex flex-col items-center">
                    <h1 className="text-center">No Farm Details</h1>
                    <FarmDetails />
                </div>
            }

            {/* Farm Details but not approved */}
            {!loading && farm.farm_id && !farm.is_approved &&
                <div className="min-w-full flex flex-col items-center">
                    <NinetyRing width={25} height={25} />
                    <h1 className="text-center">Waiting approval...</h1>
                    <p className="text-center">It seems that you have farm details but is unverified by the current owner of the farm</p>
                </div>
            }

            {/* Farm Details and approved */}
            {!loading && farm.farm_id && farm.is_approved && ponds.ponds.length > 0 &&
                <>
                    {/* Dropdown menu for pond names */}
                    <div className="flex flex-row align-middle items-center space-x-4">
                        <span className="font-bold text-[#205083]">Pond: </span>

                        <Select value={selectedPond} onValueChange={handleSelectChange}>
                            <SelectTrigger className="font-bold text-[#205083] w-[150px] shadow-none border-0 border-b-2 border-orange-300 rounded-none px-1">
                                <SelectValue placeholder="Select Pond" />
                            </SelectTrigger>
                            <SelectContent>
                                {
                                    ponds?.ponds.map((pond) =>
                                        <SelectItem key={pond.pond_id} value={pond.pond_id}>
                                            {pond.name}
                                        </SelectItem>
                                    )
                                }

                            </SelectContent>
                        </Select>
                    </div>

                    {/* Pond details */}
                    <PondView pond_id={selectedPond} />
                </>
            }

            {/* Farm Details and approved but no ponds */}
            {!loading && farm.farm_id && farm.is_approved && ponds.ponds.length == 0 &&
                <div className="min-w-full mt-[30vh] flex flex-col items-center select-none justify-center">
                    <p className="text-center">It seems that you have no pond/s for&nbsp;
                        <span className="font-semibold">{farm.name}</span>,
                    </p>
                    <p className="mb-8">please begin by adding the pond</p>

                    {/* Dialog for adding ponds */}
                    <AddPondDialog farm_id={farm.farm_id} page="dashboard" />
                </div>
            }

        </div>
    )
}