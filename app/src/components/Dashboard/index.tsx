"use client";

import { useEffect, useState } from "react";
import { Select, SelectTrigger, SelectContent, SelectItem, SelectValue } from "@/components/ui/select";
import PondView from "./PondView";
import { NinetyRing } from "react-svg-spinners";
import Image from "next/image"
import axios from "axios";
import FarmDetails from "./FarmDetails";
import { useRouter } from "next/navigation";
import AddPondDialog from "../ui/dialog/AddPond.dialog";
import moment from "moment-timezone";

export default function Dashboard() {
    const router = useRouter();
    const [ponds, setPonds] = useState<{ ponds: any[], noPonds: boolean }>({ ponds: [], noPonds: false });
    const [selectedPond, setSelectedPond] = useState<string>("");
    const [farm, setFarm] = useState<any>({});
    const [loading, setLoading] = useState(true);
    const [farmerCount, setFarmerCount] = useState<number>(0);
    const [readingCount, setReadingCount] = useState<number>(0);
    const [datetime, setDatetime] = useState<string>("");
    const [timezone, setTimezone] = useState<string>("");

    useEffect(() => {
        setDatetime(moment().format("h:mm a, MMM dd, yyyy"));
        setTimezone(moment.tz.guess());
        const intervs = setInterval(() => {
            setDatetime(moment().format("h:mm a, MMM dd, yyyy"));
        });
        return () => clearInterval(intervs);
    }, []);

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
                axios.get(`/api/farm/farmer?farm_id=${response.data.results[0].farm_id}`).then(response => {
                    if (!response.data.results || response.data.results.length <= 0) {
                        return;
                    };
                    setFarmerCount(response.data.results.length);
                    axios.get(`/api/farm/reading/count?farm_id=${response.data.results[0].farm_id}`).then(response => {
                        if (!response.data.results || response.data.results.length <= 0) {
                            return;
                        }
                        setReadingCount(response.data.results[0].count);
                    }).catch(error => {
                        console.error(error);
                    }).finally(() => {
                        setLoading(false);
                    });
                });
            }).catch(error => {
                console.error(error);
            })
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
        <div className="p-4 md:p-[24px] h-fit">

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
                    <div className="flex flex-col h-auto select-none space-y-4">

                        <div className="flex flex-col mb-5 xl:mb-0">

                            {/* quick widgets */}
                            <div className="grid grid-cols-4 w-full gap-3 gap-y-5">

                                {/* # of time*/}
                                <div className="bg-white border-2 rounded-2xl p-5 flex flex-row justify-center space-x-5 xl:space-x-0 xl:space-y-5 xl:flex-col items-center">
                                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-[40px] h-[40px]">
                                        <path strokeLinecap="round" strokeLinejoin="round" d="M12 6v6h4.5m4.5 0a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z" />
                                    </svg>
                                    <div className="flex flex-col space-x-1">
                                        <span>{datetime}</span>
                                        <span>@ {timezone}</span>
                                    </div>
                                </div>

                                {/* # of ponds */}
                                <div className="bg-white border-2 rounded-2xl p-5 flex flex-row justify-center space-x-5 xl:space-x-0 xl:space-y-5 xl:flex-col items-center">
                                    <Image alt="shrimp-ponds" src="/widget-shrimp.png" width={40} height={40}></Image>
                                    <div className="flex flex-row space-x-1">
                                        <span className="font-bold">{ponds.ponds.length || 0}</span>
                                        <span>Shrimp Ponds</span>
                                    </div>
                                </div>

                                {/* staff */}
                                <div className="bg-white border-2 rounded-2xl p-5 flex flex-row justify-center space-x-5 xl:space-x-0 xl:space-y-5 xl:flex-col items-center">
                                    <Image alt="shrimp-ponds" src="/widget-staff.png" width={50} height={40}></Image>
                                    <div className="flex flex-row space-x-1">
                                        <span className="font-bold">{farmerCount}</span>
                                        <span>Staff</span>
                                    </div>
                                </div>

                                {/* # of readings */}
                                <div className="bg-white border-2 rounded-2xl p-5 flex flex-row justify-center space-x-5 xl:space-x-0 xl:space-y-5 xl:flex-col items-center">
                                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-[40px] h-[40px]">
                                        <path strokeLinecap="round" strokeLinejoin="round" d="M3.375 19.5h17.25m-17.25 0a1.125 1.125 0 0 1-1.125-1.125M3.375 19.5h7.5c.621 0 1.125-.504 1.125-1.125m-9.75 0V5.625m0 12.75v-1.5c0-.621.504-1.125 1.125-1.125m18.375 2.625V5.625m0 12.75c0 .621-.504 1.125-1.125 1.125m1.125-1.125v-1.5c0-.621-.504-1.125-1.125-1.125m0 3.75h-7.5A1.125 1.125 0 0 1 12 18.375m9.75-12.75c0-.621-.504-1.125-1.125-1.125H3.375c-.621 0-1.125.504-1.125 1.125m19.5 0v1.5c0 .621-.504 1.125-1.125 1.125M2.25 5.625v1.5c0 .621.504 1.125 1.125 1.125m0 0h17.25m-17.25 0h7.5c.621 0 1.125.504 1.125 1.125M3.375 8.25c-.621 0-1.125.504-1.125 1.125v1.5c0 .621.504 1.125 1.125 1.125m17.25-3.75h-7.5c-.621 0-1.125.504-1.125 1.125m8.625-1.125c.621 0 1.125.504 1.125 1.125v1.5c0 .621-.504 1.125-1.125 1.125m-17.25 0h7.5m-7.5 0c-.621 0-1.125.504-1.125 1.125v1.5c0 .621.504 1.125 1.125 1.125M12 10.875v-1.5m0 1.5c0 .621-.504 1.125-1.125 1.125M12 10.875c0 .621.504 1.125 1.125 1.125m-2.25 0c.621 0 1.125.504 1.125 1.125M13.125 12h7.5m-7.5 0c-.621 0-1.125.504-1.125 1.125M20.625 12c.621 0 1.125.504 1.125 1.125v1.5c0 .621-.504 1.125-1.125 1.125m-17.25 0h7.5M12 14.625v-1.5m0 1.5c0 .621-.504 1.125-1.125 1.125M12 14.625c0 .621.504 1.125 1.125 1.125m-2.25 0c.621 0 1.125.504 1.125 1.125m0 1.5v-1.5m0 0c0-.621.504-1.125 1.125-1.125m0 0h7.5" />
                                    </svg>
                                    <div className="flex flex-row space-x-1">
                                        <span className="font-bold">{readingCount || 0}</span>
                                        <span>Readings</span>
                                    </div>
                                </div>
                            </div>
                        </div>


                        {/* pond details */}
                        <div className="bg-white w-full h-fit rounded-2xl border-2">
                            {/* Dropdown menu for pond names */}
                            <div className="flex flex-row space-x-5 justify-between xl:justify-start items-center border-0 p-5 border-b-2">
                                <div className="text-xl font-regular">
                                    Pond:
                                </div>

                                <Select value={selectedPond} onValueChange={handleSelectChange}>
                                    <SelectTrigger className="font-bold text-[#205083] w-[200px] shadow-none border-2 rounded-full border-orange-300 bg-orange-100/40 px-4">
                                        <SelectValue placeholder="Select Pond" />
                                    </SelectTrigger>
                                    <SelectContent>
                                        {ponds?.ponds.map((pond) =>
                                            <SelectItem key={pond.pond_id} value={pond.pond_id}>
                                                {pond.name}
                                            </SelectItem>)
                                        }
                                    </SelectContent>
                                </Select>
                            </div>

                            {/* Pond details */}
                            <div className="p-6">
                                <PondView pond_id={selectedPond} />
                            </div>
                        </div>
                    </div>
                </>
            }

            {/* Farm Details and approved but no ponds */}
            {!loading && farm.farm_id && farm.is_approved && ponds.ponds.length == 0 &&
                <div className="min-w-full mt-[30vh] flex flex-col items-center select-none justify-center">
                    <p className="text-center">It seems that you have no pond/s for&nbsp;
                        <span className="font-semibold">{farm.name}</span>,
                    </p>
                    <p className="mb-8">please begin by adding the pond</p>
                    <AddPondDialog farm_id={farm.farm_id} page="dashboard" />
                </div>
            }

        </div>
    )
}