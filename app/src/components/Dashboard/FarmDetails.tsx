import {
    Dialog,
    DialogContent,
    DialogDescription,
    DialogFooter,
    DialogHeader,
    DialogTitle,
    DialogTrigger,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Separator } from "../ui/separator";
import { RadioGroup, RadioGroupItem } from "../ui/radio-group";
import { Label } from "../ui/label";
import { Command, CommandInput, CommandItem, CommandList } from "../ui/command";
import { useEffect, useState } from "react";
import { Checkbox } from "../ui/checkbox";

export default function FarmDetails() { 
    const [enabledGroup, setEnabledGroup] = useState<"default" | "search">("default");

    const matcher = [
        { id: "1", name: "Farm 1" },
        { id: "2", name: "Farm 2" },
        { id: "3", name: "Farm 3" },
        { id: "4", name: "Farm 4" },
    ];

    const handleSearchChange = (e: any) => {
    };

    const handleRadioSelect = (value: any) => {
        setEnabledGroup(value);
    };

    return (
        <Dialog>
            <DialogTrigger asChild>
                <Button variant="outline">Enter Farm Details</Button>
            </DialogTrigger>
            <DialogContent className="max-w-full sm:max-w-[600px]">
                <RadioGroup onValueChange={handleRadioSelect} defaultValue={enabledGroup} className="space-y-4">
                    <div className="flex flex-col space-y-2">
                        <div className="flex items-center space-x-2">
                            <RadioGroupItem value="search" id="r1" />
                            <Label htmlFor="r1">Find Existing Farm</Label>
                        </div>
                        <div className="flex flex-col">
                            <Command onChange={handleSearchChange} className="bg-white">
                                <CommandInput disabled={enabledGroup === "default"} placeholder="Search farm name or address.." />
                            </Command>
                        </div>
                        <div className="flex justify-end items-center space-x-2">
                            <Checkbox id="terms" disabled={enabledGroup === "default"} />
                            <label htmlFor="terms" className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">
                                I am an Owner
                            </label>
                        </div>
                    </div>
                    <Separator />
                    <div className="flex items-center space-x-2">
                        <RadioGroupItem value="default" id="r1" />
                        <Label htmlFor="r1">Enter New Farm Details</Label>
                    </div>
                </RadioGroup>
                <DialogFooter>
                    <Button type="submit" className="bg-sky-600 text-white">Save changes</Button>
                </DialogFooter>
            </DialogContent>
        </Dialog>
    )
}