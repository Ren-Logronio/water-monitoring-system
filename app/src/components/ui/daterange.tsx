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
            <div className="border py-1 px-3 bg-white rounded-md flex flex-row items-center space-x-2 text-[14px] max-w-[256px]">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-4 h-4">
                    <path strokeLinecap="round" strokeLinejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 0 1 2.25-2.25h13.5A2.25 2.25 0 0 1 21 7.5v11.25m-18 0A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75m-18 0v-7.5A2.25 2.25 0 0 1 5.25 9h13.5A2.25 2.25 0 0 1 21 11.25v7.5m-9-6h.008v.008H12v-.008ZM12 15h.008v.008H12V15Zm0 2.25h.008v.008H12v-.008ZM9.75 15h.008v.008H9.75V15Zm0 2.25h.008v.008H9.75v-.008ZM7.5 15h.008v.008H7.5V15Zm0 2.25h.008v.008H7.5v-.008Zm6.75-4.5h.008v.008h-.008v-.008Zm0 2.25h.008v.008h-.008V15Zm0 2.25h.008v.008h-.008v-.008Zm2.25-4.5h.008v.008H16.5v-.008Zm0 2.25h.008v.008H16.5V15Z" />
                </svg>
                { selected === "custom" && <span>
                    {!dateFrom && !dateTo && "Choose Date Range"}
                    {dateFrom && !moment(dateFrom).isSame(moment(dateTo)) && !moment(dateFrom).isSame(moment.unix(0)) && `${moment(dateFrom).format("MMM DD, YYYY")} --`}
                    {dateFrom && moment(dateFrom).isSame(moment.unix(0)) && "Until"}
                    {dateTo && !moment(dateTo).isSame(dateTo, "day") && ` ${moment(dateTo).format("MMM DD, YYYY")}`}
                    {dateTo && moment(dateTo).isSame(dateTo, "day") && ` Today`}
                </span>}
                {
                    selected !== "custom" && <span>
                        {selected === "all" && "All date and time"}
                        {selected === "30" && "Last 30 days"}
                        {selected === "7" && "Last 7 days"}
                        {selected === "24h" && "Last 24 hours"}
                    </span>
                }
            </div>
        </PopoverTrigger>
        <PopoverContent className="flex flex-row space-x-2 min-w-[700px] m-2">
            <div className="flex-1 flex flex-col justify-start items-center space-y-2 text-[14px]">
                <span className=" text-start self-start">Range</span>
                <Button onClick={() => setSelected("all")} variant="ghost" disabled={selected === "all"} className={`w-full ${selected === "all" && 'bg-slate-300'}`}>All</Button>
                <Button onClick={() => setSelected("30")} variant="ghost" disabled={selected === "30"} className={`w-full ${selected === "30" && 'bg-slate-300'}`}>30 days</Button>
                <Button onClick={() => setSelected("7")} variant="ghost" disabled={selected === "7"} className={`w-full ${selected === "7" && 'bg-slate-300'}`}>7 days</Button>
                <Button onClick={() => setSelected("24h")} variant="ghost" disabled={selected === "24h"} className={`w-full ${selected === "24h" && 'bg-slate-300'}`}>24 hours</Button>
                <Button onClick={() => setSelected("custom")} variant="ghost" disabled={selected === "custom"} className={`w-full ${selected === "custom" && 'bg-slate-300'}`}>Custom</Button>
            </div>
            <Calendar
                mode="range"
                month={dateFromMonth}
                onMonthChange={(month) => (moment(month).isBefore(moment(dateTo), "month") ) && setDateFromMonth(month)}
                selected={{ from: dateFrom || moment().toDate(), to: dateTo } as DateRange}
                onSelect={(value) => { value?.from && setDateFrom(value.from); value?.to && setDateTo(value.to) }}
                disabled={(date: Date) => { return selected !== "custom" }} />
            <Calendar
                mode="range"
                month={dateToMonth}
                onMonthChange={(month) => (moment(month).isAfter(moment(dateFrom), "month") ) && setDateToMonth(month)}
                selected={{ from: dateFrom || moment().toDate(), to: dateTo } as DateRange}
                onSelect={(value) => { value?.from && setDateFrom(value.from); value?.to && setDateTo(value.to) }}
                disabled={(date) => selected !== "custom" || moment(date).isAfter(moment()) || moment(date).isSame(moment(dateFrom)) || moment(date).isBefore(dateFrom)}
            />
        </PopoverContent>
    </Popover>
}