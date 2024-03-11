import { useEffect, useState } from "react";
import { Button } from "../ui/button";
import { Dialog, DialogClose, DialogContent, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from "../ui/dialogNoX";
import { Input } from "../ui/input";
import { Label } from "../ui/label";
import axios from "axios";
import { format } from "date-fns";
import { useParameterDatasheetStore } from "@/store/parameterDatasheetStore";


export default function EditReading({ reading }: { reading: any }) {
    const [currentReadingForm, setCurrentReadingForm] = useState(reading);
    const { editRowData } = useParameterDatasheetStore();
    const [open, setOpen] = useState(false);
    const [loading, setLoading] = useState(false);

    const handleEdit = () => {
        const editedDateTime = format(`${currentReadingForm.date} ${currentReadingForm.time}`, "yyyy-MM-dd'T'HH:mm");
        setLoading(true);
        axios.put("/api/reading", {
            reading_id: reading.reading_id,
            value: currentReadingForm.reading,
            recorded_at: editedDateTime,
        }).then(res => {
            console.log(res);
            setLoading(false);
            setOpen(false);
            editRowData({ ...reading, edit_recorded_at: currentReadingForm.date, edit_time: currentReadingForm.time, reading: currentReadingForm.reading, date: format(editedDateTime, "MMM dd, yyyy"), time: format(editedDateTime, "h:mm a") })
        }).catch(err => {
            console.log(err);
            setLoading(false);
        });
    }

    return <Dialog open={open} onOpenChange={setOpen}>
        <DialogTrigger asChild>
            <Button className="text-sky-600 p-2 flex flex-row space-x-2" variant="ghost">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" className="w-5 h-5">
                    <path d="m5.433 13.917 1.262-3.155A4 4 0 0 1 7.58 9.42l6.92-6.918a2.121 2.121 0 0 1 3 3l-6.92 6.918c-.383.383-.84.685-1.343.886l-3.154 1.262a.5.5 0 0 1-.65-.65Z" />
                    <path d="M3.5 5.75c0-.69.56-1.25 1.25-1.25H10A.75.75 0 0 0 10 3H4.75A2.75 2.75 0 0 0 2 5.75v9.5A2.75 2.75 0 0 0 4.75 18h9.5A2.75 2.75 0 0 0 17 15.25V10a.75.75 0 0 0-1.5 0v5.25c0 .69-.56 1.25-1.25 1.25h-9.5c-.69 0-1.25-.56-1.25-1.25v-9.5Z" />
                </svg>
                <p>Edit</p>
            </Button>
        </DialogTrigger>
        <DialogContent onInteractOutside={(e: any) => { e.preventDefault() }}>
            <DialogHeader>
                <DialogTitle>Edit Reading</DialogTitle>
            </DialogHeader>
            <div className="flex flex-row space-x-2">
                <div className="flex flex-col space-y-2">
                    <Label>Reading</Label>
                    <Input type="number" value={currentReadingForm.reading} step={0.01} onChange={e => setCurrentReadingForm({ ...currentReadingForm, reading: parseFloat(e.target.value) })} />
                </div>
                <div className="flex flex-col space-y-2">
                    <Label>Date</Label>
                    <Input type="date" value={currentReadingForm.date} onChange={e => { setCurrentReadingForm({ ...currentReadingForm, date: e.target.value }) }} />
                </div>
                <div className="flex flex-col space-y-2">
                    <Label>Time</Label>
                    <Input type="time" value={currentReadingForm.time} onChange={e => setCurrentReadingForm({ ...currentReadingForm, time: e.target.value })} />
                </div>
            </div>
            <DialogFooter>
                <DialogClose asChild>
                    <Button variant="outline">Cancel</Button>
                </DialogClose>
                <Button disabled={loading} onClick={handleEdit} type="submit">
                    Edit
                </Button>
            </DialogFooter>
        </DialogContent>
    </Dialog>
}