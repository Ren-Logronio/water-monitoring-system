import axios from "axios";
import { useEffect, useState } from "react"
import AddPondDialog from "../ui/dialog/AddPond.dialog";
import { NinetyRing } from "react-svg-spinners";
import { Badge } from "../ui/badge";
import PondOptions from "./PondOptions";
import useFarm from "@/hooks/useFarm";
import { addPoints } from "../Openlayers/utils/addPoints";
import { pointData } from "../Openlayers/utils/dummy/pointData";
import { removePoints } from "../Openlayers/utils/removePoints";
import { useRouter } from "next/navigation";
import moment from "moment";


export default function PondList({ farm_id }: { farm_id: number }) {
    const [ponds, setPonds] = useState<any[]>([])
    const [loading, setLoading] = useState(true);
    const { selectedFarm } = useFarm();
    const [error, setError] = useState<string | null>(null);
    const router = useRouter();


    // for demo purposes
    function getPointData() {
        pointData.forEach((point) => {
            // console.log("point: ", point);
            addPoints(point.coordinates, point.name, point.id);
        });
    }


    // get the farm data
    useEffect(() => {
        console.log("initializing ponds")

        const fetchPonds = async () => {
            setLoading(true);
            setError(null);

            // get the ponds from the database
            try {
                const response = await axios.get(`/api/farm/pond?farm_id=${farm_id}`);
                console.log("RESULTING PONDS", response.data.results);
                setPonds(response.data.results || []);

                // get the coordinate data to add to the point vector source
                response.data.results.forEach((pond: any) => {
                    let coordinates = [pond.longitude, pond.latitude]; // longitude, latitude
                    let name = pond.name;
                    let id = pond.pond_id;
                    console.log("pond: ", pond, "coordinates: ", coordinates, "name: ", name, "id: ", id);
                    // add the points to the vector source
                    addPoints(coordinates, name, id); // uncommment this line kung may data na from the database
                });
            } catch (error) {
                console.error(error);
                setError("Failed to load ponds. Please try again.");
            } finally {
                setLoading(false);
            }
        };

        fetchPonds();
    }, [farm_id]);

    const handleRemovePond = (pond_id: number) => {
        setPonds(ponds.filter(pond => pond.pond_id !== pond_id));
        router.push(`/farm?farm_id=${farm_id}`);
        window.location.reload();
    };

    const handleEditPond = (updatedPond: any) => {
        setPonds(prevPonds => prevPonds.map(pond => pond.pond_id === updatedPond.pond_id ? updatedPond : pond));
        router.push(`/farm?farm_id=${farm_id}`);
        window.location.reload();
    };



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
                                <div className={` size-2 rounded-full  ${pond.device_id && pond.status === "ACTIVE" && moment(pond.last_established_connection).isBetween(moment().subtract(10, "minute"), moment()) && "bg-green-600"} ${pond.device_id && pond.status === "IDLE" && "bg-orange-500"} ${(!pond.device_id || (pond?.last_established_connection && !moment(pond.last_established_connection).isBetween(moment().subtract(10, "minute"), moment())) || pond.status === "INACTIVE") && "bg-slate-500"}`}></div>
                                <p className=" font-medium">{pond.name}</p>
                            </div>

                            {/* dropdown options */}
                            {(selectedFarm.role === "OWNER" || "") && <PondOptions pond_id={pond.pond_id} updateCallback={handleEditPond} deleteCallback={handleRemovePond} pond_data={ponds} />}
                        </div>

                        <div className="flex flex-col mt-1">
                            <p className="text-sm">{pond.method[0].toUpperCase() + pond.method.slice(1).toLowerCase()} pond</p>

                            {/* Badges */}
                            <div className="flex flex-row mt-4 space-x-2">
                                {/* Farm plot */}
                                {pond.device_id && <Badge key={pond} variant={"default"} className="m-0 w-fit">
                                    Device: {pond.device_id}
                                </Badge>}

                                <Badge key={pond} variant={"default"} className={`m-0 w-fit ${pond.status === "ACTIVE" && `${moment(pond.last_established_connection).isBetween(moment().subtract(10, "minute"), moment()) ? "text-green-600 border-green-600" : ""}`}`}>
                                    Status: {(pond.status === "ACTIVE" && `${moment(pond.last_established_connection).isBetween(moment().subtract(10, "minute"), moment()) ? "Online" : `Offline (${moment(pond.last_established_connection).from(moment())})` }`) || "No Device"}
                                </Badge>
                            </div>

                        </div>
                    </div>
                })}
                {(selectedFarm.role === "OWNER" || "") && <AddPondDialog farm_id={farm_id} page="farm" />}
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