"use client";

import axios from "axios";
import { useEffect, useState } from "react";
import FarmDetails from "../Dashboard/FarmDetails";
import { NinetyRing } from "react-svg-spinners";
import { Button } from "../ui/button";
import ApproveStaff from "./ApproveStaff";
import DeleteStaff from "./DeleteStaff";

export default function Staff() {
    const [farm, setFarm] = useState<any>({});
    const [me, setMe] = useState<any>({});
    const [farmers, setFarmers] = useState<any[]>([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        axios.get("/api/farm").then(response => {
            if (!response.data.results || response.data.results.length <= 0) {
                setFarm({ none: true });
                return;
            }
            setFarm({ ...response.data.results[0], none: false });
            axios.get(`/api/farm/farmer?farm_id=${response.data.results[0].farm_id}`).then(response => {
                if (!response.data.results || response.data.results.length <= 0) {
                    setFarmers([]);
                    return;
                };
                setMe(response.data.results.filter((i: any) => i.me)[0]);
                setFarmers(response.data.results.filter((i: any) => !i.me));
            }).catch(error => {
                console.error(error);
            }).finally(() => {
                setLoading(false);
            });
        }).catch(error => {
            console.error(error);
        });
    }, [])

    const handleApprove = (farmer_id: number) => {
        setFarmers(farmers.map(i => i.farmer_id === farmer_id ? { ...i, is_approved: true } : i));
    };

    const handleDelete = (farmer_id: number) => {
        setFarmers(farmers.filter(i => i.farmer_id !== farmer_id));
    };

    return (
        <div className="relative p-4 h-[calc(100vh-56px)]">
            {
                loading && <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 flex flex-row justify-center space-x-2"><NinetyRing /><p>Loading...</p></div>
            }
            {
                !loading && farm.none && <div className="absolute flex flex-col justify-center items-center min-w-[300px] left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2"><div>No farm details</div><FarmDetails /></div>
            }
            {
                !loading && !farm.none && <>
                    <div className="flex flex-col space-y-2">
                        <p key={me.farmer_id} className="">
                            {me.lastname}, {me.firstname} {me.middlename && me.middlename} {me.role === "OWNER" ? "(Owner)" : "(Staff)"} {me.is_approved && "(Approved)"}
                        </p>
                        {
                            farmers.length <= 0 && <div>No staff</div>
                        }
                        {
                            farmers.length > 0 && farmers.map((i, index) => <div key={index} className="flex flex-row items-center space-x-4">
                                <p className="">
                                    {i.lastname}, {i.firstname} {i.middlename && i.middlename}
                                </p>
                                {me.role === "OWNER" && !i.is_approved && <ApproveStaff staff={i} approveCallback={handleApprove} />}
                                {me.role === "OWNER" && <DeleteStaff staff={i} deleteCallback={handleDelete} />}
                            </div>)
                        }
                    </div>
                </>
            }
        </div>
    )
}