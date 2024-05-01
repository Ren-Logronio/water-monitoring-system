"use client";

import { usePathname } from "next/navigation";
import { useEffect, useState } from "react";
import { ScrollArea } from "../ui/scroll-area";
import Image from "next/image";

import NavigationButton from "./NavigationButton";
import { Separator } from "../ui/separator";
import axios from "axios";
import { format } from "date-fns";
import Notifications from "./Notifications";
import { pathIsSignIn, pathIsSignUp } from "@/utils/PathChecker";
import Account from "./Account";

interface NavigationBarProps {
    children?: React.ReactNode;
};

export default function NavigationBar({ children }: NavigationBarProps): React.ReactNode {
    const [farm, setFarm] = useState({ name: "", none: false });
    const [navBarLoading, setNavBarLoading] = useState(true);
    const path = usePathname();
    const title = ["Water", "Monitoring", "System"];

    useEffect(() => {
        if (pathIsSignIn(path) || pathIsSignUp(path)) {
            setFarm({ name: "", none: false });
            setNavBarLoading(true);
            console.log("Nav fetch disabled");
            return;
        };

        axios.get("/api/farm").then(response => {
            if (!response.data.results || response.data.results.length <= 0) {
                setFarm({ ...farm, none: true });
                return;
            }
            setFarm({ ...response.data.results[0], none: false });
        }).catch(error => {
            console.error(error);
        }).finally(() => {
            setNavBarLoading(false);
        });

    }, [path]);

    const convertToTitleCase = (str: string) => {
        return str.split(' ').map((word) => word[0].toUpperCase() + word.slice(1)).join(' ');
    }

    const nav = !!path && path.split('/')[1] && path.split('/').slice(1).map((i, idx) => idx === path.split('/').slice(1).length - 1 ? convertToTitleCase(i) : `${convertToTitleCase(i)} > `);

    if (["/signin", "/", "/signup"].includes(path) || path.startsWith("/pdf")) {
        return <>{children}</>;
    }

    return (
        <div className="min-h-screen min-w-full flex flex-row">
            <div className="relative p-1 py-8 md:pt-[42px] md:pb-[28px] md:px-[42px] transition-all min-w-[80px] max-w-[90px] md:max-w-[316px] flex-1 border-r border-indigo-100 bg-white space-y-[44px]">

                {/* Icon and Title */}
                <div className="flex flex-row justify-center items-center pointer-events-none select-none ">
                    <Image src="/logo-orange-cropped.png" alt="Logo" height={32} width={87} className="aspect-auto" />
                    <div className="hidden flex-col items-start justify-center md:flex">
                        {/* Water Monitoring System title */}
                        {title.map((text) => (
                            <p key={text} className="transition-all leading-7 text-[24px] font-semibold text-[#FF9B42]">{text}</p>
                        ))
                        }
                    </div>
                </div>

                {/* Navigation Buttons */}
                <div className="flex flex-col space-y-2">
                    <NavigationButton disabled={navBarLoading || farm.none} path="/dashboard" imagePath="/dashboard.png" text="Dashboard" />
                    <NavigationButton disabled={navBarLoading || farm.none} path="/farm" imagePath="/farm.png" text="Farm" />
                    <NavigationButton disabled={navBarLoading || farm.none} path="/staff" imagePath="/staff.png" text="Staff" />
                    {/* <NavigationButton disabled={navBarLoading || farm.none} path="/preferences" imagePath="/preferences.png" text="Preferences" /> */}
                </div>

                <Separator className="bg-indigo-100" />

                <div className="flex flex-col mx-auto md:mx-0 space-y-2">
                    <p className="text-[#205083] hidden md:flex  pb-2 pl-2">Parameters</p>
                    <NavigationButton disabled={navBarLoading || farm.none} shortcut="TMP" path="/parameter/temperature/datasheet" text="Temperature" />
                    <NavigationButton disabled={navBarLoading || farm.none} shortcut="pH" path="/parameter/ph/datasheet" text="pH Level" />
                    <NavigationButton disabled={navBarLoading || farm.none} shortcut="AMN" path="/parameter/ammonia/datasheet" text="Ammonia" />
                    <NavigationButton disabled={navBarLoading || farm.none} shortcut="TDS" path="/parameter/tds/datasheet" text="Total Dissolved Solids" />
                </div>
                <div className="absolute bottom-[28px] left-1/2 -translate-x-1/2 hidden md:flex flex-col text-center text-sm h-fit text-[#205083]">
                    <p>Ternary Operators</p>
                    <p>Capstone Project 2023-2024</p>
                </div>
            </div>


            <div className="flex-1 flex-grow flex flex-col h-full">
                <div className="flex-grow min-h-[54px] bg-white shadow-sm flex flex-row items-center justify-end sm:justify-between px-[24px]">
                    {!farm.none ? <div className={`flex-row items-center space-x-[20px] hidden sm:flex transition-all ${path.startsWith("/farm") ? "opacity-0" : "opacity-100"}`}>
                        {farm.name ?
                            <h5 className={`text-blue-800 font-bold transition-all`}>
                                {farm.name}
                            </h5> : <div className="w-[80px] h-[32px] bg-gray-500 animate-pulse"></div>}
                        <Separator orientation="vertical" className="bg-indigo-100 h-7" />
                        <p className=" text-[12px] text-neutral-500">{!path.startsWith("/farm") && nav}</p>
                    </div>
                        : <div>No Farm</div>
                    }
                    <div className="flex flex-row items-center justify-end space-x-[20px]">
                        <Notifications disabled={navBarLoading} />
                        <Separator className="h-7 bg-indigo-100" orientation="vertical" />
                        <Account disabled={farm.none} setNavBarLoading={setNavBarLoading} />
                    </div>
                </div>
                <ScrollArea className={`flex flex-col shrink-0 h-[calc(100vh-54px)] overflow-y-auto`}>
                    {children}
                </ScrollArea>
            </div>
        </div>
    )
}