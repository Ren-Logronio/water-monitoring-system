import { Dialog, DialogClose, DialogContent, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from "../ui/dialogNoX";
import { Button } from "../ui/button";
import { useState } from "react";
import { NinetyRing } from "react-svg-spinners";
import axios from "axios";
import { useParams, useRouter } from "next/navigation";
import { useParameterDatasheetStore } from "@/store/parameterDatasheetStore";

export default function DeleteReading({ reading_id }: { reading_id: number }) {
    const [open, setOpen] = useState(false);
    const { deleteRowData } = useParameterDatasheetStore();
    const router = useRouter();
    const { parameter } = useParams();
    const [loading, setLoading] = useState(false);
    const handleDelete = () => {
        setLoading(true);
        axios.delete(`/api/reading?reading_id=${reading_id}`).then(res => {
            console.log(res);
            setLoading(false);
            setOpen(false);
            deleteRowData(reading_id);
        }).catch(err => {
            console.log(err);
            setLoading(false);
        })
    }

    return <Dialog open={open} onOpenChange={setOpen}>
        <DialogTrigger asChild>
            <Button className="text-red-600 p-2 flex flex-row space-x-2" variant="ghost">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" className="w-5 h-5">
                    <path fillRule="evenodd" d="M8.75 1A2.75 2.75 0 0 0 6 3.75v.443c-.795.077-1.584.176-2.365.298a.75.75 0 1 0 .23 1.482l.149-.022.841 10.518A2.75 2.75 0 0 0 7.596 19h4.807a2.75 2.75 0 0 0 2.742-2.53l.841-10.52.149.023a.75.75 0 0 0 .23-1.482A41.03 41.03 0 0 0 14 4.193V3.75A2.75 2.75 0 0 0 11.25 1h-2.5ZM10 4c.84 0 1.673.025 2.5.075V3.75c0-.69-.56-1.25-1.25-1.25h-2.5c-.69 0-1.25.56-1.25 1.25v.325C8.327 4.025 9.16 4 10 4ZM8.58 7.72a.75.75 0 0 0-1.5.06l.3 7.5a.75.75 0 1 0 1.5-.06l-.3-7.5Zm4.34.06a.75.75 0 1 0-1.5-.06l-.3 7.5a.75.75 0 1 0 1.5.06l.3-7.5Z" clipRule="evenodd" />
                </svg>
                <p>Delete</p>
            </Button>
        </DialogTrigger>
        <DialogContent onInteractOutside={(e: any) => { e.preventDefault() }}>
            <DialogHeader>
                <DialogTitle>Delete Reading</DialogTitle>
            </DialogHeader>
            <div className="flex flex-row space-x-2">
                <p>Are you sure you want to delete this reading?</p>
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