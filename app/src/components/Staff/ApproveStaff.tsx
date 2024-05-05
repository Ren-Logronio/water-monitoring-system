import { Dialog, DialogClose, DialogContent, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from "../ui/dialogNoX";
import { Button } from "../ui/button";
import { useState } from "react";
import { NinetyRing } from "react-svg-spinners";
import axios from "axios";
import { DropdownMenuItem } from "../ui/dropdown-menu";

export default function ApproveStaff({ staff, approveCallback }: { staff: any, approveCallback: (farmer_id: number) => void }) {
    const [open, setOpen] = useState(false);
    const [loading, setLoading] = useState(false);
    const handleApprove = () => {
        setLoading(true);
        axios.patch(`/api/farm/farmer?farmer_id=${staff.farmer_id}`).then(res => {
            setLoading(false);
            approveCallback(staff.farmer_id);
            setOpen(false);
        }).catch(err => {
            console.log(err);
            setLoading(false);
        })
    }

    return <Dialog open={open} onOpenChange={setOpen}>
        <DialogTrigger asChild>
            <Button disabled={loading} variant="outline" className="cursor-pointer">Accept</Button>
        </DialogTrigger>
        <DialogContent onInteractOutside={(e: any) => { e.preventDefault() }}>
            <DialogHeader>
                <DialogTitle>Approve {staff.role.toLowerCase()} request</DialogTitle>
            </DialogHeader>
            <div className="flex flex-row space-x-2">
                <p>Are you sure you want to add {staff.lastname}, {staff.firstname} as {staff.role.toLowerCase()} of the farm?</p>
            </div>
            <DialogFooter>
                <Button disabled={loading} onClick={handleApprove} variant="default" className="flex flex-row space-x-2">
                    {loading ?
                        <><NinetyRing color="currentColor" /><p>Loading..</p></>
                        :
                        "Approve"}
                </Button>
                <DialogClose asChild>
                    <Button disabled={loading} variant="outline">Cancel</Button>
                </DialogClose>
            </DialogFooter>
        </DialogContent>
    </Dialog>
}