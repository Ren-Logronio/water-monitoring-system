import { useState } from "react";
import { Popover, PopoverTrigger, PopoverContent } from "./popover";
import { RadioGroup, RadioGroupItem } from "./radio-group";
import { Calendar } from "./calendar";

export default function DaterangePopover() {
    const [dateFrom, setDateFrom] = useState<Date | null>(null);
    const [dateFromMonth, setDateFromMonth] = useState<string | null>(null);
    const [dateTo, setDateTo] = useState<Date | null>(null);
    const [dateToMonth, setDateToMonth] = useState<string | null>(null);
    
    return <Popover>
        <PopoverTrigger>
            {!dateFrom && !dateTo && "Choose Date Range"}
        </PopoverTrigger>
        <PopoverContent className="flex flex-row space-x-2">
            <RadioGroup>
                <RadioGroupItem value="30">Last 30 Days</RadioGroupItem>
                <RadioGroupItem value="7">Last 7 Days</RadioGroupItem>
                <RadioGroupItem value="3">Last 7 Days</RadioGroupItem>
                <RadioGroupItem value="24h">Last 24 Hours</RadioGroupItem>
                <RadioGroupItem value="custom">Custom</RadioGroupItem>
            </RadioGroup>
            <Calendar />
            <Calendar />
        </PopoverContent>
    </Popover>
}