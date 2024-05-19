"use client";

import { Dialog, DialogClose, DialogContent, DialogFooter, DialogHeader, DialogTitle } from "../ui/dialogNoX";
import { Button } from "../ui/button";
import { useMemo, useState } from "react";
import { NinetyRing } from "react-svg-spinners";
import axios from "axios";
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger } from "../ui/dropdown-menu";
import { Label } from "../ui/label";
import { Input } from "../ui/input";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "../ui/select";
import { Switch } from "../ui/switch";
import { useVectorLayerStore } from "@/store/vectorLayerStore";

// map component
import MapView from "../Openlayers/map";
import { polygonLayer } from "../Openlayers/utils/polygonLayer";
import { labelLayer } from "../Openlayers/utils/labelLayer";
import useFarm from "@/hooks/useFarm";
import { pointLayer } from "../Openlayers/utils/layer/pointLayer";
import { removePoints } from "../Openlayers/utils/removePoints";
import { useRouter } from "next/navigation";


// Pond Interface
interface Pond {
    user_id: number;
    farm_id: number;
    pond_id: number;
    device_id: string | null;
    status: string | null;
    last_established_connection: string | null;
    name: string;
    width: number;
    length: number;
    depth: number;
    method: string;
    message: string;
}

// instantiate the map component outside the component to prevent unnecessary re-renders
const { newMap: MapBuilder, selectedFeature } = MapView();



export default function PondOptions({ pond_id, updateCallback, deleteCallback, pond_data }: { pond_id: number, updateCallback: (pond: Pond) => void, deleteCallback: (pond_id: number) => void, pond_data: any }) {
    const ponds = pond_data;
    const [openDeleteDialog, setOpenDeleteDialog] = useState(false);
    const [openDisconnectDialog, setOpenDisconnectDialog] = useState(false);
    const [openEditDialog, setOpenEditDialog] = useState(false);
    const { selectedFarm: farm } = useFarm();
    const router = useRouter();
    const [loading, setLoading] = useState(false);
    const [currentPond, setCurrentPond] = useState<any>(null);

    const point_layer = useMemo(() => {
        return pointLayer();
    }, [openEditDialog, pond_id, pond_data]);

    const thisPond = useMemo(() => {
        return pond_data.find((pond: any) => pond.pond_id === pond_id);
    }, [openEditDialog, pond_id, pond_data]);

    // function to handle delete pond
    const handleDelete = () => {
        setLoading(true);
        axios.delete(`/api/pond?pond_id=${pond_id}`).then(res => {
            setLoading(false);
            deleteCallback(pond_id);
            setOpenDeleteDialog(false);
        }).catch(err => {
            console.log(err);
            setLoading(false);
        })
    }

    // function to handle input field updates
    const handleInputChange = (e: any) => {
        // switch case to handle input change
        setCurrentPond({ ...currentPond, [e.target.name]: e.target.value });

    }

    // for select dropdown value change
    const handleSelectChange = (value: string) => {
        setCurrentPond({ ...currentPond as Pond, method: value });
    }

    // for <Switch /> component
    const handleSwitchChange = (value: boolean) => {
        setCurrentPond({ ...currentPond as Pond, enter_device_id: value, device_id: value ? "" : null });
    }


    // Function to handle edit dropdown
    const handleEdit = (id: any) => {
        // open edit dialog
        setOpenEditDialog(true);
        // find the pond with the id
        const pond = findPondById(ponds, id);
        // set the current pond
        setCurrentPond(pond);
    }

    // Function to find pond by id
    function findPondById(pondObjects: any, targetPondId: number): any | null {
        for (const pond of pondObjects) {
            if (pond.pond_id === targetPondId) {
                return pond;
            }
        }
        return null;
    }

    // function to handle update pond
    const handleUpdatePond = () => {
        setLoading(true);

        console.log(selectedFeature()?.getProperties());

        // check if the device_id matches the pattern
        if (currentPond?.device_id && !/^[\w\d]{8,8}-[\w\d]{4,4}-[\w\d]{4,4}-[\w\d]{4,4}-[\w\d]{12,12}$/i.test(currentPond?.device_id)) {
            setCurrentPond({ ...currentPond as Pond, message: "* Invalid Device ID", status: "red" });
            setLoading(false);
            return;
        }

        if (currentPond.enter_device_id) {
            console.log("device id:", currentPond.device_id);
            axios.get(`/api/device?device_id=${currentPond.device_id}`).then(response => {
                if (response.data.results && response.data.results.length <= 0) {
                    setCurrentPond({ ...currentPond, status: "red", message: "This device id may not exists, or had not established a connection with the system" });
                    setLoading(false);
                    return;
                }
                setCurrentPond({ ...currentPond, message: `Device (${currentPond.device_id}) found`, status: "green" });
                setTimeout(() => {
                    const { device_id, name, width, length, depth, method, latitude, longitude } = currentPond;
                    axios.patch("/api/device", { device_id: currentPond.device_id, status: "ACTIVE" }).then(response => {
                        axios.patch("/api/pond", { pond_id, device_id, name, width, length, depth, method, latitude, longitude }).then(response => {
                            setLoading(false);
                            updateCallback({ ...currentPond, device_id: currentPond.device_id, status: "ACTIVE" });
                            setOpenEditDialog(false);
                        }).catch(err => {
                            console.error(err);
                        });
                    }).catch(err => {
                        console.error(err);
                    });
                }, 2000)
            });
        } else {
            setTimeout(() => {
                const { name, width, length, depth, method, latitude, longitude } = currentPond;
                axios.patch("/api/pond", { pond_id, name, width, length, depth, method, latitude, longitude }).then(response => {
                    setLoading(false);
                    updateCallback({ ...currentPond, name, width, length, depth, method });
                    setOpenEditDialog(false);
                }).catch(err => {
                    console.error(err);
                });
            }, 2000)
        }
    }

    const handleDisconnectDevice = (device_id: string) => {
        console.log("trigger")
        setLoading(true);
        axios.delete(`/api/device?device_id=${device_id}`).then(res => {
            updateCallback({ ...currentPond, device_id: null, status: "INACTIVE" });
        }).catch(err => {
            setOpenDisconnectDialog(false);
            console.log(err);
        }).finally(() => {
            setLoading(false);
        });
    }

    // if (!farm || farm?.role !== "OWNER") {
    //     return <></>;
    // };

    return (
        <>
            {/* Delete Dialog */}
            <Dialog open={openDeleteDialog} onOpenChange={setOpenDeleteDialog}>
                <DialogContent onInteractOutside={(e: any) => { e.preventDefault() }}>
                    <DialogHeader>
                        <DialogTitle>Delete Pond</DialogTitle>
                    </DialogHeader>
                    <div className="flex flex-row space-x-2">
                        <p>Are you sure you want to delete this pond?</p>
                    </div>
                    <DialogFooter>
                        <DialogClose asChild>
                            <Button disabled={loading} variant="ghost">Cancel</Button>
                        </DialogClose>
                        <Button disabled={loading} onClick={handleDelete} variant="deleteBtn" className="flex flex-row space-x-2">
                            {loading ?
                                <><NinetyRing color="currentColor" /><p>Deleting..</p></>
                                :
                                "Delete"}
                        </Button>
                    </DialogFooter>
                </DialogContent>
            </Dialog>

            {/* Disconnect Device */}
            {
                pond_data.find((pond: any) => pond.pond_id === pond_id)
                && pond_data.find((pond: any) => pond.pond_id === pond_id).device_id &&
                <Dialog open={openDisconnectDialog} onOpenChange={setOpenDisconnectDialog}>
                    <DialogContent onInteractOutside={(e: any) => { e.preventDefault() }}>
                        <DialogHeader>
                            <DialogTitle>Disconnect Device</DialogTitle>
                        </DialogHeader>
                        <div className="flex flex-col space-x-2">
                            <p>Are you sure you want to disconnect this pond&#39;s device?</p>
                            <p className="mt-4 text-[11px] font-medium">Device: {pond_data.find((pond: any) => pond.pond_id === pond_id).device_id}</p>
                        </div>
                        <DialogFooter>
                            <DialogClose asChild>
                                <Button disabled={loading} variant="ghost">Cancel</Button>
                            </DialogClose>
                            <Button disabled={loading} onClick={() => { handleDisconnectDevice(pond_data.find((pond: any) => pond.pond_id === pond_id).device_id) }} variant="deleteBtn" className="flex flex-row space-x-2">
                                {loading ?
                                    <><NinetyRing color="currentColor" /><p>Disconnecting..</p></>
                                    :
                                    "Disconnect"}
                            </Button>
                        </DialogFooter>
                    </DialogContent>
                </Dialog>
            }

            {/* Edit Dialog */}
            <Dialog open={openEditDialog} onOpenChange={setOpenEditDialog}>
                <DialogContent onInteractOutside={(e) => e.preventDefault()} className="sm:max-w-[650px] select-none">
                    <DialogHeader>
                        <DialogTitle className="font-semibold text-xl text-neutral-800 px-2">Edit Pond</DialogTitle>
                    </DialogHeader>

                    <div className="flex flex-col xl:flex-row xl:space-x-2 space-y-3 xl:space-y-0">

                        {/* Pond details */}
                        <div className="px-2 xl:w-[600px]">
                            {/* Row 1 */}
                            <div className="flex flex-row justify-between space-x-5 my-5 xl:my-0">
                                {/* Pond name */}
                                <div className="flex flex-col space-y-2 my-1 xl:my-0 w-full">
                                    <Label className="text-md">Pond Name</Label>
                                    <Input disabled={loading} name="name" autoComplete="false" spellCheck="false" value={currentPond?.name} onChange={handleInputChange} />
                                </div>
                            </div>
                            <div className="space-y-2 xl:space-y-2 w-full mt-4 h-fit">
                                <Label className="text-md xl:text:lg">Location</Label>

                                <MapBuilder
                                    vectorLayer={point_layer}
                                    pin={true}
                                    center={[thisPond.longitude, thisPond.latitude] as [number, number]}
                                    pinOnCenter={true}
                                    onMapClick={(latitude, longitude) => setCurrentPond((prev: any) => ({ ...prev, latitude, longitude }))}
                                    className={"h-[250px] xl:h-[300px] bg-slate-200"}
                                    zoom={17}
                                />

                            </div>

                            {/* Device */}
                            <>
                                {
                                    !pond_data.find((pond: any) => pond.pond_id === pond_id).device_id &&
                                    <div className={`flex flex-row space-x-5 border-2 p-3 rounded-2xl mt-4 xl:mt-[40px] mb-3 ${0 ? "border-blue-400 bg-blue-100/30" : ""}`}>
                                        <div className="flex flex-row space-x-2 items-center w-2/5">
                                            <Switch disabled={loading} onCheckedChange={handleSwitchChange} name="has_device" />
                                            <Label>Has device?</Label>
                                        </div>

                                        <Input onChange={handleInputChange} value={currentPond?.device_id! || ""} name="device_id" placeholder="Device ID" disabled={currentPond?.device_id === null || loading}
                                            className={`bg-white ${!!currentPond?.message ? "border-red-300" : "border-slate-200"}`} autoComplete="false" spellCheck="false" />
                                    </div>
                                }
                            </>

                            {/* Error Message */}
                            {!!currentPond?.message && <p className={` text-sm text-center ${currentPond?.status === "red" ? 'text-red-600' : 'text-green-500'}`}>{currentPond?.message}</p>}

                        </div>
                    </div>

                    <DialogFooter className="xl:px-2">
                        <DialogClose asChild>
                            <Button disabled={loading} variant="ghost">Cancel</Button>
                        </DialogClose>

                        <Button disabled={loading} onClick={handleUpdatePond} variant={"addBtn_orange_solid"} className="text-white flex flex-row items-center space-x-2" type="submit">
                            {
                                loading ? <><NinetyRing color="currentColor" /><p>Updating...</p></> : <>Update Pond</>
                            }
                        </Button>
                    </DialogFooter>
                </DialogContent>
            </Dialog>

            {/* Dropdown Menu */}
            <DropdownMenu>
                <DropdownMenuTrigger>
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" fill="currentColor" className="w-4 h-4">
                        <path d="M8 2a1.5 1.5 0 1 1 0 3 1.5 1.5 0 0 1 0-3ZM8 6.5a1.5 1.5 0 1 1 0 3 1.5 1.5 0 0 1 0-3ZM9.5 12.5a1.5 1.5 0 1 0-3 0 1.5 1.5 0 0 0 3 0Z" />
                    </svg>
                </DropdownMenuTrigger>
                <DropdownMenuContent>
                    {
                        pond_data.find((pond: any) => pond.pond_id === pond_id)
                        && pond_data.find((pond: any) => pond.pond_id === pond_id).device_id &&
                        <DropdownMenuItem onClick={() => setOpenDisconnectDialog(true)}>Disconnect Device</DropdownMenuItem>
                    }
                    <DropdownMenuItem onClick={() => handleEdit(pond_id)}>Edit</DropdownMenuItem>
                    <DropdownMenuItem onClick={() => setOpenDeleteDialog(true)}>Delete</DropdownMenuItem>
                </DropdownMenuContent>
            </DropdownMenu>
        </>
    );
}
