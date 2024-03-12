"use client";

import { useEffect, useState } from "react";
import FarmDetails from "../Dashboard/FarmDetails";
import PondList from "./PondList";
import axios from "axios";

export default function Farm() {
    const [farm, setFarm] = useState<any>({});
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        axios.get("/api/farm").then(response => {
            if (!response.data.results || response.data.results.length <= 0) {
                setFarm({ none: true });
                return;
            }
            setFarm({...response.data.results[0], none: false});
        }).catch(error => {
            console.error(error);
        }).finally(() => {
            setLoading(false);
        });
    }, [])

    return (
        <div className="p-4">
            {
                loading && <div>Loading...</div>
            }
            {
                !loading && farm.none && <><div>No farm details</div><FarmDetails/></>
            }
            {
                !loading && !farm.none && <>
                    <div className="flex flex-col">
                        <p className="text-blue-800 text-2xl font-semibold">{farm.name}</p>
                        <div className="flex flex-row">
                            <p>
                                { [farm.address_street, farm.address_city, farm.address_province].filter(i => i).join(", ")}.
                            </p>
                        </div>
                    </div>
                    <PondList farm_id={farm.farm_id} />
                </>
            }
        </div>
    );
}