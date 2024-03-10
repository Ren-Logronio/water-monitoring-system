import { useEffect, useState } from "react";
import { Dialog, DialogClose, DialogContent, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from "../ui/dialogNoX";
import { Button } from "@/components/ui/button";
import { Label } from "../ui/label";
import { Input } from "../ui/input";
import { NinetyRing } from "react-svg-spinners";
import { format } from "date-fns";
import { useParams } from "next/navigation";

export default function AddReading({ pond_id }: { pond_id?: string }) {
    const { parameter } = useParams();
    const [ open, setOpen ] = useState(false);
    const [ loading, setLoading ] = useState(false);
    const [ readingForm, setReadingForm ] = useState({ reading: 0.00, date: "", time: "" });
    const [ dateTime, setDateTime ] = useState({ datetime: "" });

    useEffect(() => {
        readingForm.date && readingForm.time && setDateTime({ datetime: format(`${readingForm.date} ${readingForm.time}`, "yyyy-MM-dd'T'HH:mm") });
    }, [readingForm]);

    const handleFormSubmit = (e: any) => {
        e.preventDefault();
        setLoading(true);
        console.log("readingForm:", readingForm);
        console.log("dateTime:", dateTime);
        setTimeout(() => {
            setLoading(false);
            setOpen(false);
        }, 2000);
    }

    return <Dialog open={open} onOpenChange={setOpen}>
        <DialogTrigger asChild>
            <Button>Add</Button>
        </DialogTrigger>
        <DialogContent className="sm:max-w-lg">
            <DialogHeader>
                <DialogTitle>Add Reading ({pond_id})</DialogTitle>
            </DialogHeader>
            <div className="flex flex-row space-x-2">
                <div className="flex flex-col space-y-2">
                    <Label>Reading</Label>
                    <Input type="number" value={readingForm.reading} step={0.01} onChange={e => setReadingForm({ ...readingForm, reading: parseFloat(e.target.value) })} />
                </div>
                <div className="flex flex-col space-y-2">
                    <Label>Date</Label>
                    <Input type="date" value={readingForm.date} onChange={e => setReadingForm({ ...readingForm, date: e.target.value })} />
                </div>
                <div className="flex flex-col space-y-2">
                    <Label>Time</Label>
                    <Input type="time" value={readingForm.time} onChange={e => setReadingForm({ ...readingForm, time: e.target.value })} />
                </div>
            </div>
            <DialogFooter className="justify-end">
                <DialogClose asChild>
                    <Button disabled={loading} type="button" variant="secondary">
                        Cancel
                    </Button>
                </DialogClose>
                <Button onClick={handleFormSubmit} disabled={loading} type="submit">
                    {loading ? <div className="flex flex-row space-x-2"><NinetyRing /><p>Adding..</p></div> : "Add"}
                </Button>
            </DialogFooter>
        </DialogContent>
    </Dialog>
}