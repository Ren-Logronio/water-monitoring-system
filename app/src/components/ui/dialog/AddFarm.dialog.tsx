"use client";

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
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"



import { Button } from "@/components/ui/button";
import { Separator } from "@/components/ui/separator";
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group";
import { Label } from "@/components/ui/label";
import { Command, CommandInput, CommandItem, CommandList } from "@/components/ui/command";
import { Dispatch, SetStateAction, useEffect, useMemo, useState } from "react";
import axios from "axios";
import { ScrollArea } from "@/components/ui/scroll-area";
import { NinetyRing } from "react-svg-spinners";
import { usePathname, useRouter } from "next/navigation";

import useFarm from "@/hooks/useFarm";
import MapView from "@/components/Openlayers/map";
import { pointLayer } from "@/components/Openlayers/utils/layer/pointLayer";
import { Input } from "../input";
import { Checkbox } from "@/components/ui/checkbox";

const { newMap: MapBuilder, selectedFeature } = MapView();



export default function FarmDetails({ open, setOpen = () => { } }: { open?: boolean, setOpen?: Dispatch<SetStateAction<boolean>> }) {
    const router = useRouter();
    const pathname = usePathname();
    const { farm, appendFarm, setSelectedFarm } = useFarm();

    const [enabledGroup, setEnabledGroup] = useState<"default" | "search">("default");

    const [existingFarmForm, setExistingFarmForm] = useState<{ searchResults: any[], selectedFarm: any, isOwner: boolean, error: string }>({ searchResults: [], selectedFarm: {}, isOwner: false, error: "" });

    const [newFarmForm, setNewFarmForm] = useState<{ name: string, address_street: string, address_city: string, address_province: string, latitude: number, longitude: number, error: string }>({ name: "", address_street: "", address_city: "", address_province: "", error: "", latitude: 0, longitude: 0 });
    const [loading, setLoading] = useState(false);
    const [dialogOpen, setDialogOpen] = useState(false);
    const [searchPressTimeout, setSearchPressTimeout] = useState<any>(null);

    // clear selected farm in the form
    const clearSelectedFarm = () => {
        setExistingFarmForm({ ...existingFarmForm, selectedFarm: {} });
    }

    const points = useMemo(() => {
        return pointLayer();
    }, [open, enabledGroup]);

    const enablePin = useMemo(() => {
        return enabledGroup === "default";
    }, [enabledGroup, open])

    const center = useMemo<[number, number]>(() => {
        const resultingcenter: [number, number] = Object.keys(existingFarmForm?.selectedFarm).length > 0 ? [existingFarmForm?.selectedFarm?.longitude, existingFarmForm?.selectedFarm?.latitude] : [125.155749, 6.102898];
        console.log("Center", resultingcenter);
        return resultingcenter;
    }, [existingFarmForm.selectedFarm]);

    const centerPin = useMemo(() => {
        return Object.keys(existingFarmForm?.selectedFarm).length > 0;
    }, [existingFarmForm, enabledGroup, open]);

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
                    appendFarm(response.data.result);
                    setSelectedFarm(response.data.result);
                    handleReset();
                    setOpen(false);
                }, 2000)
            }).catch(error => {
                console.error(error);
            })
        } else {
            if (!newFarmForm.latitude || !newFarmForm.longitude) {
                setNewFarmForm({ ...newFarmForm, error: "Please select a location" });
                setLoading(false);
                return;
            }
            if (!newFarmForm.name || !newFarmForm.address_street || !newFarmForm.address_city || !newFarmForm.address_province) {
                setNewFarmForm({ ...newFarmForm, error: "Please fill in all fields" });
                setLoading(false);
                return;
            }
            if (!newFarmForm.latitude || !newFarmForm.longitude) {
                setNewFarmForm({ ...newFarmForm, error: "Please select a location" });
                setLoading(false);
                return;
            }
            axios.post("/api/farm", newFarmForm).then(response => {
                console.log(response.data);
                setTimeout(() => {
                    console.log("Refreshing");
                    appendFarm(response.data.result);
                    setSelectedFarm(response.data.result);
                    handleReset();
                    setOpen(false);
                }, 2000)
            }).catch(error => {
                console.error(error);
            })
        }
    };

    const handleLocationChange = (longitude: number, latitude: number) => {
        setNewFarmForm(prev => ({ ...prev, latitude, longitude }));
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

    // const handleRadioSelect = (value: any) => {
    //     if (value === "default") {
    //         setExistingFarmForm({ ...existingFarmForm, selectedFarm: {}, searchResults: [], error: "" });
    //     } else {
    //         setNewFarmForm({ ...newFarmForm, error: "" });
    //     }
    //     setEnabledGroup(value);
    // };

    // when the tab changes
    const handleTabChange = (value: any) => {
        console.log("TabChange", value);

        if (value === "default") {
            setExistingFarmForm({ ...existingFarmForm, selectedFarm: {}, searchResults: [], error: "" });
        } else {
            setNewFarmForm({ ...newFarmForm, error: "" });
        }
        setEnabledGroup(value);
    }

    // when the checkbox changes, set the isOwner value
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

    const handleReset = () => {
        setExistingFarmForm({ searchResults: [], selectedFarm: {}, isOwner: false, error: "" });
        setNewFarmForm({ name: "", address_street: "", address_city: "", address_province: "", error: "", latitude: 0, longitude: 0 });
        setEnabledGroup("default");
        setLoading(false);
    }

    // reset form when dialog closes
    useEffect(() => {
        if (!open) {
            handleReset();
        }
    }, [open])

    return (
        <Dialog open={open} onOpenChange={setOpen} modal={true}>
            <DialogContent onInteractOutside={e => e.preventDefault()} className="sm:max-w-[650px] select-none">


                <DialogTitle className="font-semibold text-xl text-neutral-800">Add Farm</DialogTitle>

                <div className="flex flex-col space-y-2">
                    <Tabs defaultValue="account" className="w-full" onValueChange={handleTabChange}>
                        <TabsList className="grid w-full grid-cols-2 rounded-2xl">
                            <TabsTrigger value="search" className="rounded-xl">Add existing</TabsTrigger>
                            <TabsTrigger value="default" className="rounded-xl">Add new</TabsTrigger>
                        </TabsList>

                        {/* add existing farm */}
                        <TabsContent value="search" className="relative h-[60px]" style={{ height: existingFarmForm.selectedFarm.farm_id ? "170px" : "60px" }}>

                            <div className="px-5 relative border py-4 rounded-xl space-y-3">
                                <Command onChange={handleSearchChange} className="relative rounded-xl w-full">

                                    <div className="flex flex-row">
                                        {/* input field */}
                                        <div className="w-2/3">
                                            <CommandInput disabled={enabledGroup === "default"} placeholder="Search farm name or address.." />
                                        </div>

                                        {/* checkbox */}
                                        <div className="w-1/3 flex justify-end items-center mt-2 space-x-3">
                                            <Checkbox id="terms" onChange={handleCheckboxChange} />
                                            <label htmlFor="terms" className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">
                                                I am an Owner
                                            </label>
                                        </div>
                                    </div>

                                    {/* show error message */}
                                    {existingFarmForm.error && <p className="text-red-600 text-center text-sm my-2">{existingFarmForm.error}</p>}

                                    {existingFarmForm.searchResults.length > 0 &&
                                        <ScrollArea className=" left-0 top-full mt-1 w-full h-[140px] space-y-2 z-10 bg-white">
                                            {existingFarmForm.searchResults.map((result, index) => (
                                                <div key={result.farm_id}>
                                                    <div onClick={() => { existingFarmForm.selectedFarm.farm_id !== result.farm_id && handleSearchResultSelect(result) }} className={`p-2 ${existingFarmForm.selectedFarm.farm_id !== result.farm_id && 'hover:bg-slate-100 cursor-pointer'} flex flex-row justify-between items-center`}>
                                                        <div>
                                                            <p>{result.name}</p>
                                                            <p>{result.address_street}, {result.address_city}, {result.address_province}</p>
                                                        </div>
                                                        <div>
                                                            {existingFarmForm.selectedFarm.farm_id === result.farm_id && <span className="text-sky-600">Selected</span>}
                                                        </div>
                                                    </div>
                                                    {index !== existingFarmForm.searchResults.length - 1 && <Separator />}
                                                </div>
                                            ))
                                            }
                                        </ScrollArea>
                                    }
                                </Command>

                                {/* show the selected farm */}
                                {existingFarmForm.selectedFarm.farm_id &&
                                    <div className={`flex flex-col space-y-1 px-5 py-3 bg-slate-200/75 rounded-xl ${enabledGroup === "default" && 'opacity-40'}`}>

                                        <div className="flex flex-row justify-between">
                                            <p className="text-lg font-semibold">{existingFarmForm.selectedFarm.name}</p>

                                            {/* clear button */}
                                            <button className="bg-slate-300 rounded-md p-1" onClick={clearSelectedFarm}>
                                                <svg width="20" height="20" viewBox="0 0 15 15" fill="none" xmlns="http://www.w3.org/2000/svg">
                                                    <path d="M12.8536 2.85355C13.0488 2.65829 13.0488 2.34171 12.8536 2.14645C12.6583 1.95118 12.3417 1.95118 12.1464 2.14645L7.5 6.79289L2.85355 2.14645C2.65829 1.95118 2.34171 1.95118 2.14645 2.14645C1.95118 2.34171 1.95118 2.65829 2.14645 2.85355L6.79289 7.5L2.14645 12.1464C1.95118 12.3417 1.95118 12.6583 2.14645 12.8536C2.34171 13.0488 2.65829 13.0488 2.85355 12.8536L7.5 8.20711L12.1464 12.8536C12.3417 13.0488 12.6583 13.0488 12.8536 12.8536C13.0488 12.6583 13.0488 12.3417 12.8536 12.1464L8.20711 7.5L12.8536 2.85355Z" fill="currentColor" fill-rule="evenodd" clip-rule="evenodd">
                                                    </path>
                                                </svg>
                                            </button>
                                        </div>


                                        <div className="flex flex-row space-x-2 items-center">
                                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" fill="currentColor" className="w-4 h-4">
                                                <path fillRule="evenodd" d="m7.539 14.841.003.003.002.002a.755.755 0 0 0 .912 0l.002-.002.003-.003.012-.009a5.57 5.57 0 0 0 .19-.153 15.588 15.588 0 0 0 2.046-2.082c1.101-1.362 2.291-3.342 2.291-5.597A5 5 0 0 0 3 7c0 2.255 1.19 4.235 2.292 5.597a15.591 15.591 0 0 0 2.046 2.082 8.916 8.916 0 0 0 .189.153l.012.01ZM8 8.5a1.5 1.5 0 1 0 0-3 1.5 1.5 0 0 0 0 3Z" clipRule="evenodd" />
                                            </svg>
                                            <p>{existingFarmForm.selectedFarm.address_street}, {existingFarmForm.selectedFarm.address_city}, {existingFarmForm.selectedFarm.address_province}</p>
                                        </div>
                                    </div>
                                }
                            </div>


                        </TabsContent>

                        {/* add new farm */}
                        <TabsContent value="default" className="min-h-[170px]">
                            {newFarmForm.error && <p className="text-red-600 text-center text-sm">{newFarmForm.error}</p>}


                            <div className="border rounded-xl p-4 space-y-2">

                                <div className="flex flex-row justify-center items-center space-x-4">
                                    <Label className={`text-end ${enabledGroup === "search" && "text-neutral-400"}`}>Farm Name</Label>
                                    <Input onChange={handleInputChange} disabled={enabledGroup === "search"} value={newFarmForm.name} name="name" placeholder="Enter farm name.." className="max-w-[80%]" required />
                                </div>


                                <div className="flex flex-row justify-between py-3">
                                    {/* <Label className={`text-start ${enabledGroup === "search" && "text-neutral-400"}`}>Address</Label> */}

                                    <div className="flex flex-col items-center space-y-2">
                                        <Input onChange={handleInputChange} disabled={enabledGroup === "search"} value={newFarmForm.address_street} name="address_street" placeholder="Enter street.." className="max-w-[90%]" required />
                                        <Label className={`text-end ${enabledGroup === "search" && "text-neutral-400"}`}>Street</Label>
                                    </div>

                                    <div className="flex flex-col items-center space-y-2">
                                        <Input onChange={handleInputChange} disabled={enabledGroup === "search"} value={newFarmForm.address_city} name="address_city" placeholder="Enter city.." className="max-w-[90%]" required />
                                        <Label className={`text-end ${enabledGroup === "search" && "text-neutral-400"}`}>City</Label>
                                    </div>
                                    <div className="flex flex-col items-center space-y-2">
                                        <Input onChange={handleInputChange} disabled={enabledGroup === "search"} value={newFarmForm.address_province} name="address_province" placeholder="Enter province.." className="max-w-[90%]" required />
                                        <Label className="text-end">Province</Label>
                                    </div>
                                </div>
                            </div>
                        </TabsContent>
                    </Tabs>
                </div>



                <div className="space-y-2 mt-4 xl:space-y-2 w-full h-fit">
                    <Label className="text-md xl:text:lg">Location</Label>

                    {/* Map */}
                    <MapBuilder
                        className={"h-[250px] xl:h-[300px] bg-slate-200"}
                        vectorLayer={points}
                        pin={enablePin}
                        center={center}
                        pinOnCenter={centerPin}
                        onMapClick={(latitude, longitude) => handleLocationChange(longitude, latitude)}
                        zoom={12}
                    />
                </div>


                <DialogFooter>
                    <DialogClose asChild>
                        <Button disabled={loading} variant="ghost">Cancel</Button>
                    </DialogClose>
                    <Button onClick={handleSubmit} disabled={loading} variant={"addBtn_orange_solid"} type="submit" className=" text-white flex flex-row space-x-2">
                        {loading ? <><NinetyRing color="currentColor" /><p>Loading...</p></> : <>Add farm</>}
                    </Button>
                </DialogFooter>
            </DialogContent>
        </Dialog >
    )
}