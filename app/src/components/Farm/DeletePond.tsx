import { Dialog, DialogClose, DialogContent, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from "../ui/dialogNoX";
import { Button } from "../ui/button";
import { useState } from "react";
import { NinetyRing } from "react-svg-spinners";
import axios from "axios";
import { DropdownMenuItem } from "../ui/dropdown-menu";

export default function DeleteReading({ pond_id, deleteCallback }: { pond_id: number, deleteCallback: (pond_id: number) => void }) {
    const [open, setOpen] = useState(false);
    const [loading, setLoading] = useState(false);
    const handleDelete = () => {
        setLoading(true);
        axios.delete(`/api/pond?pond_id=${pond_id}`).then(res => {
            setLoading(false);
            deleteCallback(pond_id);
            setOpen(false);
        }).catch(err => {
            console.log(err);
            setLoading(false);
        })
    }

    return <Dialog open={open} onOpenChange={setOpen}>
        <DialogTrigger asChild>
            {/* <DropdownMenuItem className="cursor-pointer">Delete</DropdownMenuItem> */}
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" fill="currentColor" className="w-4 h-4 cursor-pointer">
                <path fillRule="evenodd" d="M5 3.25V4H2.75a.75.75 0 0 0 0 1.5h.3l.815 8.15A1.5 1.5 0 0 0 5.357 15h5.285a1.5 1.5 0 0 0 1.493-1.35l.815-8.15h.3a.75.75 0 0 0 0-1.5H11v-.75A2.25 2.25 0 0 0 8.75 1h-1.5A2.25 2.25 0 0 0 5 3.25Zm2.25-.75a.75.75 0 0 0-.75.75V4h3v-.75a.75.75 0 0 0-.75-.75h-1.5ZM6.05 6a.75.75 0 0 1 .787.713l.275 5.5a.75.75 0 0 1-1.498.075l-.275-5.5A.75.75 0 0 1 6.05 6Zm3.9 0a.75.75 0 0 1 .712.787l-.275 5.5a.75.75 0 0 1-1.498-.075l.275-5.5a.75.75 0 0 1 .786-.711Z" clipRule="evenodd" />
            </svg>
        </DialogTrigger>
        <DialogContent onInteractOutside={(e: any) => { e.preventDefault() }}>
            <DialogHeader>
                <DialogTitle>Delete Pond</DialogTitle>
            </DialogHeader>
            <div className="flex flex-row space-x-2">
                <p>Are you sure you want to delete this pond?</p>
            </div>
            <DialogFooter>
                <Button disabled={loading} onClick={handleDelete} variant="destructive" className="flex flex-row space-x-2">
                    {loading ?
                        <><NinetyRing color="currentColor" /><p>Deleting..</p></>
                        :
                        "Delete"}
                </Button>
                <DialogClose asChild>
                    <Button disabled={loading} variant="outline">Cancel</Button>
                </DialogClose>
            </DialogFooter>
        </DialogContent>
    </Dialog>
}