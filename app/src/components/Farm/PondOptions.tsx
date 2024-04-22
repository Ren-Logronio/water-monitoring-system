import { Dialog, DialogClose, DialogContent, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from "../ui/dialogNoX";
import { Button } from "../ui/button";
import { useState } from "react";
import { NinetyRing } from "react-svg-spinners";
import axios from "axios";
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger } from "../ui/dropdown-menu";


export default function PondOptions({ pond_id, deleteCallback }: { pond_id: number, deleteCallback: (pond_id: number) => void }) {
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
        {/* return this dropdown */}
        {/* reference: https://github.com/radix-ui/primitives/issues/1836 */}

        <DropdownMenu>
            <DropdownMenuTrigger>
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" fill="currentColor" className="w-4 h-4">
                    <path d="M8 2a1.5 1.5 0 1 1 0 3 1.5 1.5 0 0 1 0-3ZM8 6.5a1.5 1.5 0 1 1 0 3 1.5 1.5 0 0 1 0-3ZM9.5 12.5a1.5 1.5 0 1 0-3 0 1.5 1.5 0 0 0 3 0Z" />
                </svg>
            </DropdownMenuTrigger>
            <DropdownMenuContent>
                <DropdownMenuItem className="cursor-pointer">Edit</DropdownMenuItem>
                <DropdownMenuItem onClick={() => setOpen(true)}>Delete</DropdownMenuItem>
            </DropdownMenuContent>
        </DropdownMenu>

        {/* dialog */}
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