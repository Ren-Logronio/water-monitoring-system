import { useEffect, useState } from "react";
import { Popover, PopoverTrigger, PopoverContent } from "./popover";
import { RadioGroup, RadioGroupItem } from "./radio-group";
import { Calendar } from "./calendar";
import moment from "moment";
import { Label } from "./label";
import { Button } from "./button";
import { DateRange } from "react-day-picker";

export default function DaterangePopover({ children, asChild = false, onChange }: { children?: React.ReactNode, asChild?: boolean, onChange?: (dateFrom: Date, dateTo: Date, mode: string) => void }) {
    const [selected, setSelected] = useState<string>("all");
    const [dateFrom, setDateFrom] = useState<Date>(moment.unix(0).toDate());
    const [dateFromMonth, setDateFromMonth] = useState<Date>(moment().subtract(1, 'month').toDate());
    const [dateTo, setDateTo] = useState<Date>(moment().toDate());
    const [dateToMonth, setDateToMonth] = useState<Date>(moment().toDate());

    useEffect(() => {
        if (selected === "all") {
            setDateFrom(moment.unix(0).toDate());
            setDateTo(moment().toDate());
        } else if (selected === "30") {
            setDateFrom(moment().subtract(30, 'days').toDate());
            setDateTo(moment().toDate());
        } else if (selected === "7") {
            setDateFrom(moment().subtract(7, 'days').toDate());
            setDateTo(moment().toDate());
        } else if (selected === "24h") {
            setDateFrom(moment().subtract(1, 'day').toDate());
            setDateTo(moment().toDate());
        }
    }, [selected]);

    useEffect(() => {
        onChange && onChange(dateFrom, dateTo, selected);
    }, [dateFrom, dateTo, selected]);

    return <Popover>
        <PopoverTrigger>
            {!dateFrom && !dateTo && "Choose Date Range"}
            {dateFrom && !moment(dateFrom).isSame(moment(dateTo)) && !moment(dateFrom).isSame(moment.unix(0)) && `From ${moment(dateFrom).format("MMM DD, YYYY")} To`}
            {dateFrom && moment(dateFrom).isSame(moment.unix(0)) && "Until"}
            {dateTo ? ` ${moment(dateTo).format("MMM DD, YYYY")}` : ` Now (${moment().format("MMM DD, YYYY")})`}
        </PopoverTrigger>
        <PopoverContent className="flex flex-row space-x-2 min-w-[700px] m-2">
            <div className="flex-1 flex flex-col justify-start items-center space-y-2">
                <Button onClick={() => setSelected("all")} variant="ghost" disabled={selected === "all"} className={`w-full ${selected === "all" && 'bg-slate-300'}`}>All</Button>
                <Button onClick={() => setSelected("30")} variant="ghost" disabled={selected === "30"} className={`w-full ${selected === "30" && 'bg-slate-300'}`}>30 days</Button>
                <Button onClick={() => setSelected("7")} variant="ghost" disabled={selected === "7"} className={`w-full ${selected === "7" && 'bg-slate-300'}`}>7 days</Button>
                <Button onClick={() => setSelected("24h")} variant="ghost" disabled={selected === "24h"} className={`w-full ${selected === "24h" && 'bg-slate-300'}`}>24 hours</Button>
                <Button onClick={() => setSelected("custom")} variant="ghost" disabled={selected === "custom"} className={`w-full ${selected === "custom" && 'bg-slate-300'}`}>Custom</Button>
            </div>
            <Calendar
                mode="range"
                month={dateFromMonth}
                onMonthChange={(month) => (moment(month).isBefore(moment(dateTo), "month") || moment(month).isSame(moment(dateTo), "month")) && setDateFromMonth(month)}
                selected={{ from: dateFrom || moment().toDate(), to: dateTo } as DateRange}
                onSelect={(value) => { value?.from && setDateFrom(value.from); value?.to && setDateTo(value.to) }}
                disabled={(date: Date) => { return selected !== "custom" }} />
            <Calendar
                mode="range"
                month={dateToMonth}
                onMonthChange={(month) => (moment(month).isAfter(moment(dateFrom), "month") || moment(month).isSame(moment(dateFrom), "month")) && setDateToMonth(month)}
                selected={{ from: dateFrom || moment().toDate(), to: dateTo } as DateRange}
                onSelect={(value) => { value?.from && setDateFrom(value.from); value?.to && setDateTo(value.to) }}
                disabled={(date) => selected !== "custom" || moment(date).isAfter(moment()) || moment(date).isSame(moment(dateFrom)) || moment(date).isBefore(dateFrom)}
            />
        </PopoverContent>
    </Popover>
}