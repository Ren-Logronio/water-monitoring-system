"use client";

import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Slider } from "@/components/ui/slider";
import { calculateWQI, calculateWQIDebug } from "@/utils/SimpleFuzzyLogicWaterQuality";
import axios from "axios";
import { useMemo, useState } from "react";

export default function Test() {
    const [params, setParams] = useState({
        temperature: [0], ph: [0], ammonia: [0], tds: [0],
    });
    const [deviceId, setDeviceId] = useState("");

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

    const handleSend = () => {
        if (!deviceId || !/^[\d]{4,4}-[\w]{4,4}$/gs.test(deviceId)) {
            return;
        }
        axios.post("/api/device/reading", {
            device_id: deviceId,
            TMP: params.temperature[0],
            PH: params.ph[0],
            TDS: params.tds[0],
            AMN: params.ammonia[0],
        }).then((response: any) => {
            console.log(response.data);
        }).catch((error: any) => {
            console.error(error);
        });
    }

    return <div className="flex flex-col h-screen w-full p-4 space-y-5">
        <div className="flex flex-row space-x-4 pr-4">
            <div className="flex flex-col space-y-4 w-full">
                <Label>Device ID</Label>
                <Input type="text" value={deviceId} onChange={(e) => setDeviceId(e.target.value)} className="max-w-[300px]"></Input>
            </div>
        </div>
        <div className="flex flex-row space-x-4 pr-4">
            <div className="flex flex-col space-y-4 w-full">
                <Label>Temperature</Label>
                <Slider value={params.temperature} min={15} max={38} onValueChange={handleSetValue("temperature")}></Slider>
            </div>
            <p className="flex flex-col text-end justify-end items-end w-[200px]">{params.temperature[0]} °C</p>
        </div>
        <div className="flex flex-row space-x-4 pr-4">
            <div className="flex flex-col space-y-4 w-full">
                <Label>Ph</Label>
                <Slider value={params.ph} min={4} max={10} onValueChange={handleSetValue("ph")} step={0.1}></Slider>
            </div>
            <p className="flex flex-col text-end justify-end items-end w-[200px]">{params.ph[0]} </p>
        </div>
        <div className="flex flex-row space-x-4 pr-4">
            <div className="flex flex-col space-y-4 w-full">
                <Label>TDS</Label>
                <Slider value={params.tds} max={750} onValueChange={handleSetValue("tds")}></Slider>
            </div>
            <p className="flex flex-col text-end justify-end items-end w-[200px]">{params.tds[0]} ppm</p>
        </div>
        <div className="flex flex-row space-x-4 pr-4">
            <div className="flex flex-col space-y-4 w-full">
                <Label>Ammonia</Label>
                <Slider value={params.ammonia} max={75} onValueChange={handleSetValue("ammonia")}></Slider>
            </div>
            <p className="flex flex-col text-end justify-end items-end w-[200px]">{params.ammonia[0]} ppm</p>
        </div>
        <div>Temp: {wqi.temperature}</div>
        <div>Ph: {wqi.ph}</div>
        <div>Ammonia: {wqi.ammonia}</div>
        <div>TDS: {wqi.tds}</div>
        <div>WQI: {wqi.wqi}</div>
        <Button onClick={handleSend}>Send</Button>
    </div>
}