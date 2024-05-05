"use client";

import { useEffect, useMemo, useState } from "react";
import FarmDetails from "../Dashboard/FarmDetails";
import PondList from "./PondList";
import axios from "axios";
import { NinetyRing } from "react-svg-spinners";
import useFarm from "@/hooks/useFarm";

export default function Farm() {
    const { selectedFarm, farmsLoading } = useFarm();
    const loading = useMemo(() => {
        return farmsLoading;
    }, [farmsLoading]);
    const farm = useMemo(() => {
        return selectedFarm;
    }, [selectedFarm]);

    return (
        <div className="relative p-4">
            {/* loading spinner */}
            {loading &&
                <div className="flex flex-row justify-center items-center space-x-2 mt-10">
                    <NinetyRing width={40} height={40} />
                </div>
            }

            {
                !loading && farm.none && <><div>No farm details</div><FarmDetails /></>
            }
            {
                !loading && !farm.none && <div>
                    <div className="flex flex-col">
                        <p className="text-[#205083] text-2xl font-semibold">{farm.name}</p>
                        <div className="flex flex-row">
                            <p>
                                {[farm.address_street, farm.address_city, farm.address_province].filter(i => i).join(", ")}.
                            </p>
                        </div>
                    </div>

                    <div className="text-lg text-[#205083] font-bold mt-10">
                        Ponds
                    </div>

                    {/* Ponds */}
                    <PondList farm_id={farm.farm_id} />
                </div>
            }
        </div>
    );
}