import { Dialog, DialogClose, DialogContent, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from "../ui/dialogNoX";
import { Button } from "../ui/button";
import { useState } from "react";
import { NinetyRing } from "react-svg-spinners";
import axios from "axios";
import { DropdownMenuItem } from "../ui/dropdown-menu";

export default function ApproveStaff({ staff, deleteCallback }: { staff: any, deleteCallback: (farmer_id: number) => void }) {
    const [open, setOpen] = useState(false);
    const [loading, setLoading] = useState(false);
    const handleDelete = () => {
        setLoading(true);
        axios.delete(`/api/farm/farmer?farmer_id=${staff.farmer_id}`).then(res => {
            setLoading(false);
            deleteCallback(staff.farmer_id);
            setOpen(false);
        }).catch(err => {
            console.log(err);
            setLoading(false);
        })
    }

    return <Dialog open={open} onOpenChange={setOpen}>
        <DialogTrigger asChild>
            <Button disabled={loading} variant="destructive" className="cursor-pointer">Remove</Button>
        </DialogTrigger>
        <DialogContent onInteractOutside={(e: any) => { e.preventDefault() }}>
            <DialogHeader>
                <DialogTitle>Remove staff</DialogTitle>
            </DialogHeader>
            <div className="flex flex-row space-x-2">
                <p>Are you sure you want to remove {staff.lastname}, {staff.firstname} from the staff list?</p>
            </div>
            <DialogFooter>
                <Button disabled={loading} onClick={handleDelete} variant="destructive" className="flex flex-row space-x-2">
                    {loading ?
                        <><NinetyRing color="currentColor" /><p>Removing..</p></>
                        :
                        "Remove"}
                </Button>
                <DialogClose asChild>
                    <Button disabled={loading} variant="outline">Cancel</Button>
                </DialogClose>
            </DialogFooter>
        </DialogContent>
    </Dialog>
}