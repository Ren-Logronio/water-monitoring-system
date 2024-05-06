import {
    Dialog,
    DialogContent,
    DialogFooter,
    DialogHeader,
    DialogTitle,
    DialogTrigger,
} from "@/components/ui/dialogNoX";
import { Button } from "../button";
import { Label } from "../label";
import { DialogClose } from "../dialog";
import { Input } from "../input";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "../select";
import { useEffect, useState } from "react";
import axios from "axios";
import { useRouter } from "next/navigation";
import { NinetyRing } from "react-svg-spinners";
import { Switch } from "../switch";


// default values for the form
const PondDetailsProps = {
    enter_device_id: false,
    device_id: "",
    name: "My Pond",
    width: 0.00,
    length: 0.00,
    depth: 0.00,
    method: "SEMI-INTENSIVE",
    message: "",
    status: "red",
}


export default function AddPondDialog({ farm_id, page }: { farm_id: number, page: string }) {
    const router = useRouter();
    const [dialogOpen, setDialogOpen] = useState(false);
    const [loading, setLoading] = useState(false);

    // initial values for the form
    const [pondForm, setPondForm] = useState(PondDetailsProps);

    const handleCheckboxChange = (value: any) => {
        setPondForm({ ...pondForm, device_id: "", enter_device_id: value });

    };

    const handleInputChange = (e: any) => {
        setPondForm({ ...pondForm, [e.target.name]: e.target.value });
    };

    const handleSelectChange = (value: string) => {
        setPondForm({ ...pondForm, method: value });
    }

    const handleSubmit = () => {
        if (pondForm.enter_device_id && !/^[\w\d]{8,8}-[\w\d]{4,4}-[\w\d]{4,4}-[\w\d]{4,4}-[\w\d]{12,12}$/i.test(pondForm.device_id)) {
            setPondForm({ ...pondForm, message: "* Invalid Device ID", status: "red" });
            return;
        }
        setLoading(true);
        if (pondForm.enter_device_id) {
            console.log("device id:", pondForm.device_id);
            axios.get(`/api/device?device_id=${pondForm.device_id}`).then(response => {
                if (response.data.results && response.data.results.length <= 0) {
                    setPondForm({ ...pondForm, message: "This device id may not exists, or had not established a connection with the system" });
                    setLoading(false);
                    return;
                }
                setPondForm({ ...pondForm, message: `Device (${pondForm.device_id}) found`, status: "green" });
                setTimeout(() => {
                    const { device_id, name, width, length, depth, method } = pondForm;
                    axios.patch("/api/device", { device_id: pondForm.device_id, status: "ACTIVE" }).then(response => {
                        axios.post("/api/pond", {
                            device_id, farm_id, name, width, length, depth, method
                        }).then(response => {
                            router.replace(`/redirect?w=/${page}`);
                        }).catch(err => {
                            console.error(err);
                        })
                    }).catch(err => {
                        console.error(err);
                    });
                }, 2000)
            });
        } else {
            setTimeout(() => {
                const { name, width, length, depth, method } = pondForm;
                axios.post("/api/pond", {
                    farm_id, device_id: null, name, width, length, depth, method
                }).then(response => {
                    router.replace(`/redirect?w=/${page}`);
                }).catch(err => {
                    console.error(err);
                })
            }, 2000)
        }
    }

    // reset the form when the dialog is closed
    useEffect(() => {
        if (!dialogOpen) setPondForm(PondDetailsProps);
    }, [dialogOpen]);


    return <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
        <DialogTrigger>
            {/* return custom elements depending on page */}

            {/* Dashboard page */}
            {page === "dashboard" &&
                <Button variant="addBtn_orange_outline">
                    + Add new pond
                </Button>
            }

            {/* Farm page */}
            {page === "farm" &&
                <div className="h-fit flex flex-col transition-all justify-center items-center border-2 border-collapse border-orange-300 bg-orange-300/20 rounded-xl p-2 cursor-pointer hover:bg-orange-300 group">
                    <div className="flex flex-row items-center">
                        <p className="text-center py-2 text-md font-semibold transition-all ease-in-out duration-200">+ Add New Pond</p>
                    </div>
                </div>
            }

        </DialogTrigger>

        {/* Dialog content */}
        <DialogContent onInteractOutside={(e) => e.preventDefault()} className="sm:max-w-[625px] select-none">
            <DialogHeader>
                <DialogTitle className="font-semibold text-xl text-neutral-800 px-2">Add New Pond</DialogTitle>
            </DialogHeader>
            <div className="px-2">

                {/* Row 1 */}
                <div className="flex flex-row justify-between space-x-5 my-5">
                    {/* Pond name */}
                    <div className="flex flex-col space-y-2 my-1 w-full">
                        <Label className="text-md">Pond Name</Label>
                        <Input disabled={loading} onChange={handleInputChange} value={pondForm.name} name="name" autoComplete="false" spellCheck="false" />
                    </div>

                    {/* Type of farming */}
                    <div className="flex flex-col space-y-2 my-1">
                        <Label className="text-md">Type of Farming</Label>
                        <Select disabled={loading} name="method" onValueChange={handleSelectChange} value={pondForm.method}>
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
                            <Input disabled={loading} onChange={handleInputChange} min={0} max={10000} maxLength={5} type="number" name="width" value={pondForm.width} step={1.0} />
                            <p className="hidden text-sm text-red-600"></p>
                        </div>
                        <div className="flex flex-row items-center space-x-2">
                            <Label>Length</Label>
                            <Input disabled={loading} onChange={handleInputChange} min={0} max={10000} maxLength={5} type="number" name="length" value={pondForm.length} step={1.0} />
                            <p className="hidden text-sm text-red-600"></p>
                        </div>
                        <div className="flex flex-row items-center space-x-2">
                            <Label>Depth</Label>
                            <Input disabled={loading} onChange={handleInputChange} min={0} max={10000} maxLength={5} type="number" name="depth" value={pondForm.depth} step={1.0} />
                            <p className="hidden text-sm text-red-600"></p>
                        </div>
                    </div>
                </div>

                {/* Device */}
                <div className={`flex flex-row space-x-5 border-2 p-3 rounded-2xl mt-10 mb-3 ${pondForm.enter_device_id ? "border-blue-400 bg-blue-100/30" : ""}`}>
                    <div className="flex flex-row space-x-2 items-center w-2/5">
                        <Switch disabled={loading} checked={pondForm.enter_device_id} onCheckedChange={handleCheckboxChange} />
                        <Label>Has device?</Label>
                    </div>

                    <Input disabled={loading || !pondForm.enter_device_id} onChange={handleInputChange} value={pondForm.device_id} name="device_id" placeholder="Device ID"
                        className={`bg-white ${!!pondForm.message ? "border-red-300" : "border-slate-200"}`} autoComplete="false" spellCheck="false" />
                </div>

                {/* Error Message */}
                {!!pondForm.message && <p className={` text-sm text-center ${pondForm.status === "red" ? 'text-red-600' : 'text-green-500'}`}>{pondForm.message}</p>}

            </div>
            <DialogFooter>
                <DialogClose asChild>
                    <Button disabled={loading} variant="ghost">Cancel</Button>
                </DialogClose>

                <Button disabled={loading} onClick={handleSubmit} variant={"addBtn_orange_solid"} className="text-white flex flex-row items-center space-x-2" type="submit">
                    {
                        loading ? <><NinetyRing color="currentColor" /><p>Adding...</p></> : <>Add Pond</>
                    }
                </Button>
            </DialogFooter>
        </DialogContent>
    </Dialog>
}