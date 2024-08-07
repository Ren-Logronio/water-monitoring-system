'use client';

import {
    Dialog,
    DialogClose,
    DialogContent,
    DialogDescription,
    DialogFooter,
    DialogHeader,
    DialogTitle,
    DialogTrigger,
} from "@/components/ui/dialogNoX";
import { Button } from "@/components/ui/button";
import { Separator } from "../ui/separator";
import { RadioGroup, RadioGroupItem } from "../ui/radio-group";
import { Label } from "../ui/label";
import { Command, CommandInput, CommandItem, CommandList } from "../ui/command";
import { useEffect, useState } from "react";
import { Checkbox } from "../ui/checkbox";
import axios from "axios";
import { ScrollArea } from "../ui/scroll-area";
import { set } from "date-fns";
import { Input } from "../ui/input";
import { NinetyRing } from "react-svg-spinners";
import { useRouter } from "next/navigation";
import { revalidatePath } from "next/cache";

export default function FarmDetails() {
    const router = useRouter();
    const [enabledGroup, setEnabledGroup] = useState<"default" | "search">("default");
    const [existingFarmForm, setExistingFarmForm] = useState<{ searchResults: any[], selectedFarm: any, isOwner: boolean, error: string }>({ searchResults: [], selectedFarm: {}, isOwner: false, error: "" });
    const [newFarmForm, setNewFarmForm] = useState<{ name: string, address_street: string, address_city: string, address_province: string, error: string }>({ name: "", address_street: "", address_city: "", address_province: "", error: "" });
    const [loading, setLoading] = useState(false);
    const [dialogOpen, setDialogOpen] = useState(false);
    const [searchPressTimeout, setSearchPressTimeout] = useState<any>(null);

    const handleSubmit = (e: any) => {
        e.preventDefault();
        console.log(e);
        setLoading(true)
        if (enabledGroup === "search") {
            if (!existingFarmForm.selectedFarm.farm_id) {
                setExistingFarmForm({ ...existingFarmForm, error: "Please select a farm" });
                setLoading(false);
                return;
            }
            axios.post("/api/farm/farmer", { farm: existingFarmForm.selectedFarm, isOwner: existingFarmForm.isOwner }).then(response => {
                console.log(response.data);
                setTimeout(() => {
                    console.log("Refreshing");
                    router.replace("/redirect?w=/dashboard");
                }, 2000)
            }).catch(error => {
                console.error(error);
            })
        } else {
            if (!newFarmForm.name || !newFarmForm.address_street || !newFarmForm.address_city || !newFarmForm.address_province) {
                setNewFarmForm({ ...newFarmForm, error: "Please fill in all fields" });
                setLoading(false);
                return;
            }
            axios.post("/api/farm", newFarmForm).then(response => {
                console.log(response.data);
                setTimeout(() => {
                    console.log("Refreshing");
                    router.replace("/redirect?w=/dashboard");
                }, 2000)
            }).catch(error => {
                console.error(error);
            })
        }
    };

    const handleSearchChange = (e: any) => {
        setExistingFarmForm({ ...existingFarmForm, searchResults: [] });
        if (searchPressTimeout) clearTimeout(searchPressTimeout);
        setSearchPressTimeout(setTimeout(() => {
            if (/\w+/i.test(e.target.value) && e.target.value.length > 2) {
                axios.get(`/api/farm/search?q=${e.target.value}`).then(response => {
                    setExistingFarmForm({ ...existingFarmForm, searchResults: response.data.results });
                }).catch(error => {
                    console.error(error);
                });
            };
        }, 600));
    };

    const handleRadioSelect = (value: any) => {
        if (value === "default") {
            setExistingFarmForm({ ...existingFarmForm, searchResults: [], error: "" });
        } else {
            setNewFarmForm({ ...newFarmForm, error: "" });
        }
        setEnabledGroup(value);
    };

    const handleCheckboxChange = (e: any) => {
        setExistingFarmForm({ ...existingFarmForm, isOwner: e.target.checked });
    }

    const handleSearchResultSelect = (farm: any) => {
        setExistingFarmForm({ ...existingFarmForm, searchResults: [], selectedFarm: farm });
    };

    const handleInputChange = (e: any) => {
        const { name, value } = e.target;
        setNewFarmForm({ ...newFarmForm, [name]: value });
    }

    return (
        <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
            <DialogTrigger asChild>
                <Button variant="outline">Enter Farm Details</Button>
            </DialogTrigger>
            <DialogContent onInteractOutside={e => e.preventDefault()} className="max-w-full sm:max-w-[600px]">
                <RadioGroup onValueChange={handleRadioSelect} defaultValue={enabledGroup} className="space-y-4">
                    <div className="flex flex-col space-y-2">
                        <div className="flex items-center space-x-2">
                            <RadioGroupItem value="search" id="r1" />
                            <Label htmlFor="r1">Find Existing Farm</Label>
                        </div>
                        <div className="relative flex flex-col">
                            <Command onChange={handleSearchChange} className="bg-white shadow-sm">
                                <CommandInput disabled={enabledGroup === "default"} placeholder="Search farm name or address.." />
                                {existingFarmForm.error && <p className="text-red-600 text-center text-sm my-2">{existingFarmForm.error}</p>}
                                {existingFarmForm.searchResults.length > 0 && (
                                    <ScrollArea className="absolute top-0 max-h-[200px] min-w-full space-y-2">
                                        {
                                            existingFarmForm.searchResults.map((result, index) => <>
                                                <div key={result.farm_id} onClick={() => { existingFarmForm.selectedFarm.farm_id !== result.farm_id && handleSearchResultSelect(result) }} className={`p-2 ${existingFarmForm.selectedFarm.farm_id !== result.farm_id && 'hover:bg-slate-100 cursor-pointer'} flex flex-row justify-between items-center`}>
                                                    <div>
                                                        <p>{result.name}</p>
                                                        <p>{result.address_street}, {result.address_city}, {result.address_province}</p>
                                                    </div>
                                                    <div>
                                                        {existingFarmForm.selectedFarm.farm_id === result.farm_id && <span className="text-sky-600">Selected</span>}
                                                    </div>
                                                </div>
                                                {index !== existingFarmForm.searchResults.length - 1 && <Separator />}
                                            </>)
                                        }
                                    </ScrollArea>
                                )}
                            </Command>
                        </div>
                        {
                            existingFarmForm.selectedFarm.farm_id && (
                                <div className={`flex flex-col space-y-1 p-2 border ${enabledGroup === "default" && 'opacity-40'} border-indigo-100`}>
                                    <p className="text-sm font-medium">Selected</p>
                                    <p className="text-lg font-semibold">{existingFarmForm.selectedFarm.name}</p>
                                    <div className="flex flex-row space-x-2 items-center">
                                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" fill="currentColor" className="w-4 h-4">
                                            <path fillRule="evenodd" d="m7.539 14.841.003.003.002.002a.755.755 0 0 0 .912 0l.002-.002.003-.003.012-.009a5.57 5.57 0 0 0 .19-.153 15.588 15.588 0 0 0 2.046-2.082c1.101-1.362 2.291-3.342 2.291-5.597A5 5 0 0 0 3 7c0 2.255 1.19 4.235 2.292 5.597a15.591 15.591 0 0 0 2.046 2.082 8.916 8.916 0 0 0 .189.153l.012.01ZM8 8.5a1.5 1.5 0 1 0 0-3 1.5 1.5 0 0 0 0 3Z" clipRule="evenodd" />
                                        </svg>
                                        <p>{existingFarmForm.selectedFarm.address_street}, {existingFarmForm.selectedFarm.address_city}, {existingFarmForm.selectedFarm.address_province}</p>
                                    </div>
                                </div>
                            )
                        }
                        <div className="flex justify-end items-center mt-2 space-x-2">
                            <Checkbox id="terms" onChange={handleCheckboxChange} disabled={enabledGroup === "default"} />
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
                    {newFarmForm.error && <p className="text-red-600 text-center text-sm">{newFarmForm.error}</p>}
                    <div className="flex flex-row justify-end items-center space-x-4">
                        <Label className={`text-end ${enabledGroup === "search" && "text-neutral-400"}`}>Farm Name</Label>
                        <Input onChange={handleInputChange} disabled={enabledGroup === "search"} value={newFarmForm.name} name="name" placeholder="Enter farm name.." className="max-w-[80%]" required />
                    </div>
                    <div className="space-y-2">
                        <Label className={`text-start ${enabledGroup === "search" && "text-neutral-400"}`}>Address</Label>
                        <div className="flex flex-row justify-end items-center space-x-4">
                            <Label className={`text-end ${enabledGroup === "search" && "text-neutral-400"}`}>Street</Label>
                            <Input onChange={handleInputChange} disabled={enabledGroup === "search"} value={newFarmForm.address_street} name="address_street" placeholder="Enter street.." className="max-w-[80%]" required />
                        </div>
                        <div className="flex flex-row justify-end items-center space-x-4">
                            <Label className={`text-end ${enabledGroup === "search" && "text-neutral-400"}`}>City</Label>
                            <Input onChange={handleInputChange} disabled={enabledGroup === "search"} value={newFarmForm.address_city} name="address_city" placeholder="Enter city.." className="max-w-[80%]" required />
                        </div>
                        <div className="flex flex-row justify-end items-center space-x-4">
                            <Label className={`text-end ${enabledGroup === "search" && "text-neutral-400"}`}>Province</Label>
                            <Input onChange={handleInputChange} disabled={enabledGroup === "search"} value={newFarmForm.address_province} name="address_province" placeholder="Enter province.." className="max-w-[80%]" required />
                        </div>
                    </div>
                </RadioGroup>
                <DialogFooter>
                    <DialogClose asChild>
                        <Button disabled={loading} variant="outline">Cancel</Button>
                    </DialogClose>
                    <Button onClick={handleSubmit} disabled={loading} type="submit" className="bg-sky-600 text-white flex flex-row space-x-2">
                        {loading ? <><NinetyRing color="currentColor" /><p>Loading...</p></> : <>Enter Farm Details</>}
                    </Button>
                </DialogFooter>
            </DialogContent>
        </Dialog >
    )
}