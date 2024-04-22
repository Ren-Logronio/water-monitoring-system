import { useEffect, useState } from "react";
import { Dialog, DialogClose, DialogContent, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from "../ui/dialogNoX";
import { Button } from "@/components/ui/button";
import { Label } from "../ui/label";
import { Input } from "../ui/input";
import { NinetyRing } from "react-svg-spinners";
import { format, } from "date-fns";
import { useRouter, useParams } from "next/navigation";
import axios from "axios";

export default function AddReading({ pond_id }: { pond_id?: string }) {
    const { parameter } = useParams();
    const router = useRouter();
    const [open, setOpen] = useState(false);
    const [loading, setLoading] = useState(false);
    const [readingForm, setReadingForm] = useState({ reading: 0.00, date: format(new Date(), "yyyy-MM-dd"), time: format(new Date(), "HH:mm") });
    const [dateTime, setDateTime] = useState<string>("");

    useEffect(() => {
        readingForm.date && readingForm.time && setDateTime(format(`${readingForm.date} ${readingForm.time}`, "yyyy-MM-dd'T'HH:mm"));
    }, [readingForm]);

    const handleFormSubmit = (e: any) => {
        e.preventDefault();
        setLoading(true);
        axios.post("/api/pond/parameter/reading", {
            pond_id,
            parameter,
            value: readingForm.reading,
            date: dateTime
        }).then(res => {
            console.log(res);
            setLoading(false);
            setOpen(false);
            router.replace(`/redirect?w=parameter/${parameter}/datasheet`);
        }).catch(err => {
            console.log(err);
            setLoading(false);
        });
    }

    return <Dialog open={open} onOpenChange={setOpen}>
        <DialogTrigger asChild>
            <Button variant={"addBtn_blue"} className="text-white">
                Add
            </Button>
        </DialogTrigger>
        <DialogContent onInteractOutside={(e: any) => { e.preventDefault() }} className="sm:max-w-lg">
            <DialogHeader>
                <DialogTitle>Add Record</DialogTitle>
            </DialogHeader>
            <div className="flex flex-row space-x-2 mt-4 mb-4">
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
                    <Button disabled={loading} type="button" variant="ghost">
                        Cancel
                    </Button>
                </DialogClose>
                <Button onClick={handleFormSubmit} disabled={loading} variant="addBtn_orange_solid" className="text-white flex flex-row space-x-2" type="submit">
                    {loading ? <div className="flex flex-row space-x-2"><NinetyRing color="currentColor" /><p>Adding..</p></div> : "Add"}
                </Button>
            </DialogFooter>
        </DialogContent>
    </Dialog>
}