import { Dialog, DialogClose, DialogContent, DialogFooter, DialogHeader, DialogTitle } from "../ui/dialogNoX";
import { Button } from "../ui/button";
import { useState } from "react";
import { NinetyRing } from "react-svg-spinners";
import axios from "axios";
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger } from "../ui/dropdown-menu";
import { Label } from "../ui/label";
import { Input } from "../ui/input";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "../ui/select";
import { Switch } from "../ui/switch";
import { set } from "date-fns";


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


export default function PondOptions({ pond_id, deleteCallback, pond_data }: { pond_id: number, deleteCallback: (pond_id: number) => void, pond_data: any }) {
    const [openDeleteDialog, setOpenDeleteDialog] = useState(false);
    const [openEditDialog, setOpenEditDialog] = useState(false);

    const [loading, setLoading] = useState(false);
    const [currentPond, setCurrentPond] = useState<Pond | null>(null);
    const ponds = pond_data;


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
        switch (e.target.name) {
            case "name":
                setCurrentPond({ ...currentPond as Pond, name: e.target.value });
                break;
            case "width":
                setCurrentPond({ ...currentPond as Pond, width: e.target.value });
                break;
            case "length":
                setCurrentPond({ ...currentPond as Pond, length: e.target.value });
                break;
            case "depth":
                setCurrentPond({ ...currentPond as Pond, depth: e.target.value });
                break;
            case "device_id":
                setCurrentPond({ ...currentPond as Pond, device_id: e.target.value });
                break;
            default:
                break;
        }

    }

    // for select dropdown value change
    const handleSelectChange = (value: string) => {
        setCurrentPond({ ...currentPond as Pond, method: value });
    }

    // for <Switch /> component
    const handleSwitchChange = (value: boolean) => {
        setCurrentPond({ ...currentPond as Pond, device_id: value ? "" : null });
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

        // check if the device_id matches the pattern
        if (currentPond?.device_id && !/^[\w\d]{8,8}-[\w\d]{4,4}-[\w\d]{4,4}-[\w\d]{4,4}-[\w\d]{12,12}$/i.test(currentPond?.device_id)) {
            setCurrentPond({ ...currentPond as Pond, message: "* Invalid Device ID", status: "red" });
            setLoading(false);
            return;
        }

        // pakiayos ko sa axios request dria Rein
        // me dont know how to do it
        axios.put(`/api/pond?pond_id=${pond_id}`, currentPond).then(res => {
            setLoading(false);
            setOpenEditDialog(false);
        }).catch(err => {
            console.log(err);
            setLoading(false);
        })
    }

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

            {/* Edit Dialog */}
            <Dialog open={openEditDialog} onOpenChange={setOpenEditDialog}>
                <DialogContent onInteractOutside={(e) => e.preventDefault()} className="sm:max-w-[625px] select-none">
                    <DialogHeader>
                        <DialogTitle className="font-semibold text-xl text-neutral-800 px-2">Edit Pond</DialogTitle>
                    </DialogHeader>
                    <div className="px-2">

                        {/* Row 1 */}
                        <div className="flex flex-row justify-between space-x-5 my-5">
                            {/* Pond name */}
                            <div className="flex flex-col space-y-2 my-1 w-full">
                                <Label className="text-md">Pond Name</Label>
                                <Input disabled={loading} name="name" autoComplete="false" spellCheck="false" value={currentPond?.name} onChange={handleInputChange} />
                            </div>

                            {/* Type of farming */}
                            <div className="flex flex-col space-y-2 my-1">
                                <Label className="text-md">Type of Farming</Label>
                                <Select disabled={loading} name="method" value={currentPond?.method} onValueChange={handleSelectChange} >
                                    <SelectTrigger className="w-[180px] border-2 border-blue-400 bg-blue-50 focus-visible:ring-blue-200/40 focus-visible:ring-4 shadow-none rounded-2xl">
                                        <SelectValue placeholder="Select..." />
                                    </SelectTrigger>
                                    <SelectContent>
                                        <SelectItem value="SEMI-INTENSIVE">Semi-Intensive</SelectItem>
                                        <SelectItem value="INTENSIVE">Intensive</SelectItem>
                                        <SelectItem value="TRADITIONAL">Traditional</SelectItem>
                                    </SelectContent>
                                </Select>
                            </div>
                        </div>

                        {/* Pond dimensions */}
                        <div className="flex flex-col space-y-[12px] my-5">
                            <Label className="text-md">
                                Dimensions of Pond
                                <span className="text-sm"> (Optional)</span>
                            </Label>

                            {/* Input fields */}
                            <div className="flex flex-row justify-between">
                                <div className="flex flex-row items-center space-x-2">
                                    <Label>Width</Label>
                                    <Input disabled={loading} min={0} max={10000} maxLength={5} type="number" name="width" step={1.0} value={currentPond?.width} onChange={handleInputChange} />
                                    <p className="hidden text-sm text-red-600"></p>
                                </div>
                                <div className="flex flex-row items-center space-x-2">
                                    <Label>Length</Label>
                                    <Input disabled={loading} min={0} max={10000} maxLength={5} type="number" name="length" step={1.0} value={currentPond?.length} onChange={handleInputChange} />
                                    <p className="hidden text-sm text-red-600"></p>
                                </div>
                                <div className="flex flex-row items-center space-x-2">
                                    <Label>Depth</Label>
                                    <Input disabled={loading} min={0} max={10000} maxLength={5} type="number" name="depth" step={1.0} value={currentPond?.depth} onChange={handleInputChange} />
                                    <p className="hidden text-sm text-red-600"></p>
                                </div>
                            </div>
                        </div>

                        {/* Device */}
                        <div className={`flex flex-row space-x-5 border-2 p-3 rounded-2xl mt-10 mb-3 ${0 ? "border-blue-400 bg-blue-100/30" : ""}`}>
                            <div className="flex flex-row space-x-2 items-center w-2/5">
                                <Switch disabled={loading} onCheckedChange={handleSwitchChange} name="has_device" />
                                <Label>Has device?</Label>
                            </div>

                            <Input onChange={handleInputChange} value={currentPond?.device_id! || ""} name="device_id" placeholder="Device ID" disabled={currentPond?.device_id === null || loading}
                                className={`bg-white ${!!currentPond?.message ? "border-red-300" : "border-slate-200"}`} autoComplete="false" spellCheck="false" />
                        </div>

                        {/* Error Message */}
                        {!!currentPond?.message && <p className={` text-sm text-center ${currentPond?.status === "red" ? 'text-red-600' : 'text-green-500'}`}>{currentPond?.message}</p>}

                    </div>
                    <DialogFooter>
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
                    <DropdownMenuItem onClick={() => handleEdit(pond_id)}>Edit</DropdownMenuItem>
                    <DropdownMenuItem onClick={() => setOpenDeleteDialog(true)}>Delete</DropdownMenuItem>
                </DropdownMenuContent>
            </DropdownMenu>
        </>
    );
}

