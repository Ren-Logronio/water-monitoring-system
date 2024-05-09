"use client";

import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import {
    Table,
    TableBody,
    TableCaption,
    TableCell,
    TableHead,
    TableHeader,
    TableRow,
} from "@/components/ui/table"
import useFarm from "@/hooks/useFarm";
import axios from "axios";
import moment from "moment";
import { useEffect, useState } from "react";
import { NinetyRing } from "react-svg-spinners";

export default function WaterQuality() {
    const { selectedFarm, farmsLoading } = useFarm();

    const [ponds, setPonds] = useState<any[]>([]);
    const [loading, setLoading] = useState(true);
    const [selectedPond, setSelectedPond] = useState<string>("");
    const [waterQualityReadings, setWaterQualityReadings] = useState<any[]>([]);

    useEffect(() => {
        if (farmsLoading) return;
        axios.get(`/api/pond`).then(response => {
            if (!response.data.results || response.data.results.length <= 0) {
                setLoading(false); 
                return;
            }
            setPonds(response.data.results);
            setSelectedPond(response.data.results.filter((pond: any) => pond.farm_id === selectedFarm.farm_id)[0]?.pond_id);
            axios.get(`/api/water-quality?pond_id=${response.data.results.filter((pond: any) => pond.farm_id === selectedFarm.farm_id)[0]?.pond_id}`).then(response => {
                setWaterQualityReadings(response.data.results);
            }).catch(error => {
                console.error(error);
            }).finally(() => {
                setLoading(false);
            });
        }).catch(error => {
            console.error(error);
        });
        return () => {
            setPonds([]);
            setSelectedPond("");
        }
    }, [farmsLoading]);

    useEffect(() => {
        if(farmsLoading) return;
        setSelectedPond(ponds.filter(pond => pond.farm_id === selectedFarm.farm_id)[0]?.pond_id);
    }, [selectedFarm, farmsLoading]);

    useEffect(() => {
        console.log("WATER QUALITY READINGS", waterQualityReadings);
    }, [waterQualityReadings])

    return (
        <div className="p-4">
            {loading && <div className="flex justify-center items-center h-40 space-x-2">
                    <NinetyRing width={40} height={40} />
                </div>}
            {!loading && <>
            <div className="flex flex-row justify-between">
                <Select value={selectedPond} onValueChange={setSelectedPond}>
                    <SelectTrigger className="w-[180px] border-2 border-orange-300 bg-orange-50 focus-visible:ring-blue-200/40 focus-visible:ring-4 shadow-none rounded-2xl">
                        <SelectValue placeholder="Select Pond" />
                    </SelectTrigger>
                    <SelectContent>
                        {
                            ponds.map(
                                (pond) => <SelectItem key={pond.pond_id} value={pond.pond_id}>{pond.name}</SelectItem>
                            )
                        }
                        {/* <SelectItem value="light">Light</SelectItem> */}
                    </SelectContent>
                </Select>
            </div>
            <Table className="mt-2">
                <TableHeader>
                    <TableRow>
                        <TableHead>#</TableHead>
                        <TableHead>Date</TableHead>
                        <TableHead>Time</TableHead>
                        <TableHead>Avg. Temperature</TableHead>
                        <TableHead>Avg. pH</TableHead>
                        <TableHead>Avg. TDS</TableHead>
                        <TableHead>Avg. Ammonia</TableHead>
                        <TableHead>Water Quality</TableHead>
                    </TableRow>
                </TableHeader>
                <TableBody>
                    {
                        waterQualityReadings?.length && waterQualityReadings.map((reading, index) => (
                            <TableRow key={index}>
                                <TableCell>{index + 1}</TableCell>
                                <TableCell>{moment(reading.timestamp).format("MMM DD, YYYY")}</TableCell>
                                <TableCell>{moment(reading.timestamp).format("hh:mm A")}</TableCell>
                                <TableCell>{reading.temperature} °C</TableCell>
                                <TableCell>{reading.ph}</TableCell>
                                <TableCell>{reading.tds} ppm</TableCell>
                                <TableCell>{reading.ammonia} ppm</TableCell>
                                <TableCell>{reading.classification}</TableCell>
                            </TableRow>
                        ))
                    }
                    {
                        !waterQualityReadings?.length && <TableRow>
                            <TableCell colSpan={8} className="text-center">No readings found.</TableCell>
                        </TableRow>
                    }
                    {/* <TableRow>
                        <TableCell className="font-medium">INV001</TableCell>
                        <TableCell>Paid</TableCell>
                        <TableCell>Credit Card</TableCell>
                        <TableCell className="text-right">$250.00</TableCell>
                    </TableRow> */}
                </TableBody>
            </Table>
            
            </>}
        </div>
    )
}