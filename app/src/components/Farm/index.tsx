"use client";

import { useEffect, useMemo, memo } from "react";
import FarmDetails from "../Dashboard/FarmDetails";
import PondList from "./PondList";
import { NinetyRing } from "react-svg-spinners";
import useFarm from "@/hooks/useFarm";

// map component
import MapView from "../Openlayers/map";
import { pointLayer } from "../Openlayers/utils/layer/pointLayer";
import { useSearchParams } from "next/navigation";

// instantiate the map component outside the component to prevent unnecessary re-renders
const { newMap: MapBuilder } = MapView();
const farm_points = pointLayer();


export default function Farm() {
    const { farms, selectedFarm, farmsLoading, setSelectedFarm } = useFarm();
    const search = useSearchParams();

    useEffect(() => {
        if (farms && (farms?.length <= 0)) return;
        const farm_id = search.get("farm_id");
        if (farm_id) {
            setSelectedFarm(farms.find((farm: any) => farm.farm_id === parseInt(farm_id)) || {});
        }
    }, [search]);

    const farm_points = useMemo(() => {
        return pointLayer();
    }, [farmsLoading, selectedFarm]);

    const center: [number, number] = useMemo(() => {
        return [selectedFarm.longitude, selectedFarm.latitude];
    }, [selectedFarm, farmsLoading])

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

            {/* farm details + ponds */}
            {!loading && !farm.none &&
                <div>
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

                    <div className="grid grid-cols-1 xl:grid-cols-2 gap-5 w-full h-fit p-3">

                        <MapBuilder
                            vectorLayer={farm_points}
                            zoom={17.7}
                            center={center}
                            className="w-full h-[500px]"
                        />
                        {/* Pond List */}
                        <PondList farm_id={farm.farm_id} />
                    </div>
                </div>
            }
        </div>
    );
}