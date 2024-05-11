import { useEffect, useState } from "react";
import { Button } from "./button";
import { DropdownMenu, DropdownMenuContent, DropdownMenuLabel, DropdownMenuRadioGroup, DropdownMenuRadioItem, DropdownMenuSeparator, DropdownMenuTrigger } from "./dropdown-menu";

type ValueLabelType = {
    value: string;
    label: string;
}

type NumberOfItemsDropdownProps = {
    setValueLabel: ValueLabelType[];
    defaultValue?: string;
    disabled?: boolean;
    onValueChange?: (value: string) => void;
}

export const DefaultValueLabelSet = [
    { value: "25", label: "25" },
    { value: "75", label: "75" },
    { value: "150", label: "150" },
    { value: "all", label: "Show All" },
]

export default function NumberOfItemsDropdown({ setValueLabel, defaultValue, onValueChange, disabled }: NumberOfItemsDropdownProps) {
    const [value, setValue] = useState<string>(defaultValue || setValueLabel[0].value);

    useEffect(() => {
        onValueChange && onValueChange(value);
    }, [value]);
    
    return <DropdownMenu>
    <DropdownMenuTrigger disabled={disabled} className="border py-1 px-3 bg-white rounded-md flex flex-row items-center space-x-2 text-[14px]">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" className="w-4 h-4">
            <path fillRule="evenodd" d="M2.625 6.75a1.125 1.125 0 1 1 2.25 0 1.125 1.125 0 0 1-2.25 0Zm4.875 0A.75.75 0 0 1 8.25 6h12a.75.75 0 0 1 0 1.5h-12a.75.75 0 0 1-.75-.75ZM2.625 12a1.125 1.125 0 1 1 2.25 0 1.125 1.125 0 0 1-2.25 0ZM7.5 12a.75.75 0 0 1 .75-.75h12a.75.75 0 0 1 0 1.5h-12A.75.75 0 0 1 7.5 12Zm-4.875 5.25a1.125 1.125 0 1 1 2.25 0 1.125 1.125 0 0 1-2.25 0Zm4.875 0a.75.75 0 0 1 .75-.75h12a.75.75 0 0 1 0 1.5h-12a.75.75 0 0 1-.75-.75Z" clipRule="evenodd" />
        </svg>
        <span>Show {value} Items</span>
    </DropdownMenuTrigger>
    <DropdownMenuContent className="w-56">
      <DropdownMenuRadioGroup value={value} onValueChange={setValue}>
        {setValueLabel.map(({ value, label }) => <DropdownMenuRadioItem key={value} value={value}>{label}</DropdownMenuRadioItem>)}
      </DropdownMenuRadioGroup>
    </DropdownMenuContent>
  </DropdownMenu>
}