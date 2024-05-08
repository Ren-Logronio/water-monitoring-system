"use client";

import { useMemo } from "react";
import FarmDetails from "../Dashboard/FarmDetails";
import PondList from "./PondList";
import { NinetyRing } from "react-svg-spinners";
import useFarm from "@/hooks/useFarm";

// map component
import MapView from "../Openlayers/map";
import { polygonLayer } from "../Openlayers/utils/polygonLayer";
import { labelLayer } from "../Openlayers/utils/labelLayer";



export default function Farm() {
    const { selectedFarm, farmsLoading } = useFarm();

    // layers for the map component, memoized to prevent re-rendering
    const farm_plots = useMemo(() => polygonLayer(), []);
    const farm_labels = useMemo(() => labelLayer(), []);

    // map component
    const { newMap: MapBuilder, selectedFeature } = MapView();


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
                        {/* Map */}
                        <MapBuilder vectorLayer={farm_plots} labelLayer={farm_labels} className="w-full h-[500px]" />

                        {/* Ponds list */}
                        <PondList farm_id={farm.farm_id} />
                    </div>
                </div>
            }
        </div>
    );
}