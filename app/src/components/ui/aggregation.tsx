import { useEffect, useState } from "react";
import { Button } from "./button";
import { DropdownMenu, DropdownMenuContent, DropdownMenuLabel, DropdownMenuRadioGroup, DropdownMenuRadioItem, DropdownMenuSeparator, DropdownMenuTrigger } from "./dropdown-menu";

type ValueLabelType = {
    value: string;
    label: string;
}

type AggregationProps = {
    setValueLabel: ValueLabelType[];
    defaultValue?: string;
    onValueChange?: (value: string) => void;
}

export const DefaultAggregationValueLabelSet = [
    { value: "minute", label: "minute" },
    { value: "hour", label: "hourly" },
    { value: "4", label: "4-hourly"},
    { value: "day", label: "daily" },
    { value: "week", label: "weekly" },
    { value: "month", label: "monthly" },
]

export default function Aggregation({ setValueLabel, defaultValue, onValueChange }: AggregationProps) {
    const [value, setValue] = useState<string>(defaultValue || setValueLabel[0].value);

    useEffect(() => {
        onValueChange && onValueChange(value);
    }, [value]);
    
    return <DropdownMenu>
    <DropdownMenuTrigger className="border py-1 px-3 bg-white rounded-md flex flex-row items-center space-x-2 text-[14px]">
    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-4 h-4">
  <path strokeLinecap="round" strokeLinejoin="round" d="M2.25 7.125C2.25 6.504 2.754 6 3.375 6h6c.621 0 1.125.504 1.125 1.125v3.75c0 .621-.504 1.125-1.125 1.125h-6a1.125 1.125 0 0 1-1.125-1.125v-3.75ZM14.25 8.625c0-.621.504-1.125 1.125-1.125h5.25c.621 0 1.125.504 1.125 1.125v8.25c0 .621-.504 1.125-1.125 1.125h-5.25a1.125 1.125 0 0 1-1.125-1.125v-8.25ZM3.75 16.125c0-.621.504-1.125 1.125-1.125h5.25c.621 0 1.125.504 1.125 1.125v2.25c0 .621-.504 1.125-1.125 1.125h-5.25a1.125 1.125 0 0 1-1.125-1.125v-2.25Z" />
</svg>

        <span>Every {value !== "4" ? value : "4 hours"}</span>
    </DropdownMenuTrigger>
    <DropdownMenuContent className="w-56">
      <DropdownMenuRadioGroup value={value} onValueChange={setValue}>
        {setValueLabel.map(({ value, label }) => <DropdownMenuRadioItem key={value} value={value}>{label}</DropdownMenuRadioItem>)}
      </DropdownMenuRadioGroup>
    </DropdownMenuContent>
  </DropdownMenu>
}