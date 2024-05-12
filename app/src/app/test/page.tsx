"use client";

import { Label } from "@/components/ui/label";
import { Slider } from "@/components/ui/slider";
import { calculateWQI, calculateWQIDebug } from "@/utils/SimpleFuzzyLogicWaterQuality";
import { useMemo, useState } from "react";

export default function Test() {
    const [params, setParams] = useState({
        temperature: [0], ph: [0], ammonia: [0], tds: [0],
    });

    const handleSetValue = (parameter: string) => {
        return (value: number[]) => {
            setParams((prev) => ({...prev, [parameter]: value}));
        }
    }

    const wqi = useMemo(() => {
        // ph: number, tds: number, ammonia: number, temperature: number
        const wqi: any = calculateWQIDebug(params.ph[0], params.tds[0], params.ammonia[0], params.temperature[0]);
        return wqi;
    }, [params]);

    return <div className="flex flex-col h-screen w-full p-4 space-y-5">
        <div className="flex flex-row space-x-4 pr-4">
            <div className="flex flex-col space-y-4 w-full">
                <Label>Temperature</Label>
                <Slider value={params.temperature} max={100} onValueChange={handleSetValue("temperature")}></Slider>
            </div>
            <p className="flex flex-col text-end justify-end items-end w-[200px]">{params.temperature[0]} °C</p>
        </div>
        <div className="flex flex-row space-x-4 pr-4">
            <div className="flex flex-col space-y-4 w-full">
                <Label>Ph</Label>
                <Slider value={params.ph} max={12} onValueChange={handleSetValue("ph")}></Slider>
            </div>
            <p className="flex flex-col text-end justify-end items-end w-[200px]">{params.ph[0]} </p>
        </div>
        <div className="flex flex-row space-x-4 pr-4">
            <div className="flex flex-col space-y-4 w-full">
                <Label>TDS</Label>
                <Slider value={params.tds} max={2000} onValueChange={handleSetValue("tds")}></Slider>
            </div>
            <p className="flex flex-col text-end justify-end items-end w-[200px]">{params.tds[0]} ppm</p>
        </div>
        <div className="flex flex-row space-x-4 pr-4">
            <div className="flex flex-col space-y-4 w-full">
                <Label>Ammonia</Label>
                <Slider value={params.ammonia} max={500} onValueChange={handleSetValue("ammonia")}></Slider>
            </div>
            <p className="flex flex-col text-end justify-end items-end w-[200px]">{params.ammonia[0]} ppm</p>
        </div>
        <div>Temp: {wqi.temperature}</div>
        <div>Ph: {wqi.ph}</div>
        <div>Ammonia: {wqi.ammonia}</div>
        <div>TDS: {wqi.tds}</div>
        <div>WQI: {wqi.wqi}</div>
    
    </div>
}