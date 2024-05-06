import axios from "axios";
import { useEffect, useState } from "react"
import AddPondDialog from "../ui/dialog/AddPond.dialog";
import { NinetyRing } from "react-svg-spinners";
import { Badge } from "../ui/badge";
import PondOptions from "./PondOptions";

export default function PondList({ farm_id }: { farm_id: number }) {
    const [ponds, setPonds] = useState<any[]>([])
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        axios.get(`/api/farm/pond?farm_id=${farm_id}`).then(response => {
            if (!response.data.results && response.data.results.length <= 0) {
                return;
            }
            setPonds(response.data.results);
            console.log(response.data.results);
        }).catch(error => {
            console.error(error);
        }).finally(() => {
            setLoading(false);
        });
    }, [farm_id]);

    const handleRemovePond = (pond_id: number) => {
        setPonds(ponds.filter(pond => pond.pond_id !== pond_id));
    };

    const handleEditPond = (pond: any) => {
        setPonds(ponds.map(p => {
            if (p.pond_id === pond.pond_id) {
                return pond;
            }
            return p;
        }));
    }

    return (
        <div>

            {/* loading spinner */}
            {loading &&
                <div className="flex flex-row justify-center items-center space-x-2 mt-10">
                    <NinetyRing width={40} height={40} />
                </div>
            }


            {!loading && <div className=" gap-2 grid grid-cols-1 space-y-1">

                {ponds.map((pond, idx) => {
                    return <div key={idx} className="flex flex-col border-2 rounded-xl p-4 h-fit select-none align-middle hover:border-orange-300 transition-all ease-in-out duration-100">
                        <div className="flex flex-row justify-between items-center">
                            <div className="flex flex-row cursor-pointer items-center space-x-2">
                                <div className={` size-2 rounded-full  ${pond.device_id && pond.status === "ACTIVE" && "bg-green-600"} ${pond.device_id && pond.status === "IDLE" && "bg-orange-500"} ${(!pond.device_id || pond.status === "INACTIVE") && "bg-slate-500"}`}></div>
                                <p className=" font-medium">{pond.name}</p>
                            </div>

                            {/* dropdown options */}
                            <PondOptions pond_id={pond.pond_id} updateCallback={handleEditPond} deleteCallback={handleRemovePond} pond_data={ponds} />
                        </div>

                        <div className="flex flex-col mt-1">
                            <p className="text-sm">{pond.method[0].toUpperCase() + pond.method.slice(1).toLowerCase()} pond</p>

                            {/* Badges */}
                            <div className="flex flex-row mt-4 space-x-2">
                                {/* Farm plot */}
                                <Badge key={pond} variant={"default"} className="m-0 w-fit">
                                    Pond plot: {pond.device_id || "No Device"}
                                </Badge>

                                <Badge key={pond} variant={"default"} className="m-0 w-fit">
                                    Status: {pond.status || "No Device"}
                                </Badge>
                            </div>

                        </div>
                    </div>
                })}
                <AddPondDialog farm_id={farm_id} page="farm" />
            </div>
            }
        </div>)
}
/*
{
    "user_id":1,
    "farm_id":1,
    "pond_id":1,
    "device_id":"88871ce9-c7b8-4afd-97ff-b211e29092f1",
    "status":"IDLE",
    "last_established_connection":"2024-03-16T09:44:49.000Z",
    "name":"Section 1",
    "width":90,
    "length":100,
    "depth":4,
    "method":"SEMI-INTENSIVE"
}

*/