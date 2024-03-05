import {
    Dialog,
    DialogContent,
    DialogDescription,
    DialogFooter,
    DialogHeader,
    DialogTitle,
    DialogTrigger,
} from "@/components/ui/dialogNoX";
import { Button } from "../ui/button";
import { Label } from "../ui/label";
import { DialogClose } from "../ui/dialog";
import { Input } from "../ui/input";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "../ui/select";
import { useState } from "react";
import axios from "axios";
import { useRouter } from "next/navigation";

export default function PondDetails({ farm_id }: { farm_id: number }) {
    const router = useRouter();
    const [dialogOpen, setDialogOpen] = useState(false);
    const [loading, setLoading] = useState(false);
    const [pondForm, setPondForm] = useState({
        device_id: "",
        name: "My Pond",
        width: 0.00,
        length: 0.00,
        depth: 0.00,
        method: "SEMI-INTENSIVE",
        message: "",
        status: "red",
    });

    const handleInputChange = (e: any) => {
        setPondForm({ ...pondForm, [e.target.name]: e.target.value });
    };

    const handleSelectChange = (value: string) => {
        setPondForm({ ...pondForm, method: value });
    }

    const handleSubmit = () => {
        axios.get(`/api/pond/device?device_id=${pondForm.device_id}`).then(response => {
            setLoading(true);
            if (response.data.results && response.data.results.length <= 0) {
                console.log("fuck")
                setPondForm({ ...pondForm, message: "This device id may not exists, or had not established a connection with the system" });
                setLoading(false);
                return;
            }
            console.log("you")
            setPondForm({ ...pondForm, message: `Device (${pondForm.device_id}) found`, status: "green" });
            setTimeout(() => {
                const { device_id, name, width, length, depth, method } = pondForm;
                axios.patch("/api/pond", {
                    device_id, farm_id, name, width, length, depth, method
                }).then(response => {
                    router.replace('/redirect?w=/dashboard');
                }).catch(err => {
                    console.error(err);
                })
            }, 2000)
        });
    }

    return <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
        <DialogTrigger asChild>
            <Button variant="outline">Enter Pond Details</Button>
        </DialogTrigger>
        <DialogContent onInteractOutside={(e) => e.preventDefault()} className="sm:max-w-[625px]">
            <DialogHeader>
                <DialogTitle className="font-normal text-neutral-800">Enter Pond Details</DialogTitle>
            </DialogHeader>
            <div className="space-y-[20px]">
                <div className="flex flex-col space-y-2">
                    <Label>* Device Id</Label>
                    <Input disabled={loading} onChange={handleInputChange} value={pondForm.device_id} name="device_id" />
                    {!!pondForm.message && <p className={` text-xs ${pondForm.status === "red" ? 'text-red-600' : 'text-green-500'}`}>{pondForm.message}</p>}
                </div>
                <div className="flex flex-col space-y-2">
                    <Label>Pond Name</Label>
                    <Input disabled={loading} onChange={handleInputChange} value={pondForm.name} name="name" />
                </div>
                <div className="flex flex-col space-y-[12px]">
                    <Label>Dimensions of Pond (Optional)</Label>
                    <div className="flex flex-row space-x-[16px]">
                        <div className="flex flex-col space-y-2">
                            <Label>Width</Label>
                            <Input disabled={loading} onChange={handleInputChange} min={0} max={10000} maxLength={5} type="number" name="width" value={pondForm.width} step={1.01} />
                            <p className="hidden text-sm text-red-600"></p>
                        </div>
                        <div className="flex flex-col space-y-2">
                            <Label>Length</Label>
                            <Input disabled={loading} onChange={handleInputChange} min={0} max={10000} maxLength={5} type="number" name="length" value={pondForm.length} step={1.01} />
                            <p className="hidden text-sm text-red-600"></p>
                        </div>
                        <div className="flex flex-col space-y-2">
                            <Label>Depth</Label>
                            <Input disabled={loading} onChange={handleInputChange} min={0} max={10000} maxLength={5} type="number" name="depth" value={pondForm.depth} step={1.01} />
                            <p className="hidden text-sm text-red-600"></p>
                        </div>
                    </div>
                </div>
                <div className="flex flex-col space-y-2">
                    <Label>* Type of Farming</Label>
                    <Select disabled={loading} name="method" onValueChange={handleSelectChange} value={pondForm.method}>
                        <SelectTrigger className="w-[180px] bg-white">
                            <SelectValue placeholder="Select Farming Type" />
                        </SelectTrigger>
                        <SelectContent>
                            <SelectItem value="SEMI-INTENSIVE">Semi-Intensive</SelectItem>
                            <SelectItem value="INTENSIVE">Intensive</SelectItem>
                            <SelectItem value="TRADITIONAL">Traditional</SelectItem>
                        </SelectContent>
                    </Select>
                </div>
            </div>
            <DialogFooter>
                <DialogClose asChild>
                    <Button disabled={loading} variant="outline">Cancel</Button>
                </DialogClose>
                <Button disabled={loading} onClick={handleSubmit} className="bg-sky-600 text-white" type="submit">Add Pond</Button>
            </DialogFooter>
        </DialogContent>
    </Dialog>
}