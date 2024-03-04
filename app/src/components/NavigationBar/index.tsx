"use client";

import { usePathname, useRouter } from "next/navigation";
import { useEffect, useState } from "react";
import { ScrollArea } from "../ui/scroll-area";
import { Button } from "../ui/button";
import { DropdownMenu, DropdownMenuContent, DropdownMenuSeparator, DropdownMenuTrigger, DropdownMenuLabel, DropdownMenuGroup, DropdownMenuItem } from "../ui/dropdown-menu";
import NavigationButton from "./NavigationButton";
import { NinetyRing } from "react-svg-spinners";
import { Separator } from "../ui/separator";
import axios from "axios";
import { format } from "date-fns";
import Notifications from "./Notifications";
import { pathIsSignIn } from "@/utils/PathChecker";
import Account from "./Account";

interface NavigationBarProps {
    children?: React.ReactNode;
};

export default function NavigationBar ({ children }: NavigationBarProps ): React.ReactNode {
    const [ farm, setFarm ] = useState({ name:"", none: false });
    const [ navBarLoading, setNavBarLoading ] = useState(true);
    const path = usePathname();

    useEffect(() => {
        if (pathIsSignIn(path)) { 
            setFarm({ name:"", none: false });
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

    const nav = !!path && path.split('/')[1] && path.split('/')[1][0] && path.split('/')[1][0].toUpperCase() + path.split('/')[1].slice(1);

    if (["/signin", "/"].includes(path)) {
        return <>{children}</>;
    }

    return (
        <div className="min-h-screen min-w-full flex flex-row">
            <div className="relative p-1 py-8 md:pt-[42px] md:pb-[28px] md:px-[42px] transition-all min-w-[80px] max-w-[90px] md:max-w-[316px] flex-1 border-r border-indigo-100 bg-white space-y-[44px]">
                <div className="flex flex-row justify-center items-center pointer-events-none select-none pr-8">
                    <img src="./logo-orange-cropped.png" className="h-[32px] md:h-[87px] aspect-auto"/>
                    <div className="flex flex-col items-start justify-center">
                        <p className="transition-all leading-7 hidden md:block text-[24px] font-semibold text-[#FF9B42]">Water</p>
                        <p className="transition-all leading-7 hidden md:block text-[24px] font-semibold text-[#FF9B42]">Monitoring</p>
                        <p className="transition-all leading-7 hidden md:block text-[24px] font-semibold text-[#FF9B42]">System</p>
                    </div>
                </div>
                <div className="flex flex-col">
                    <NavigationButton disabled={navBarLoading || farm.none} path="/dashboard" imagePath="./dashboard.png" text="Dashboard"/>
                    <NavigationButton disabled={navBarLoading || farm.none} path="/farm" imagePath="./farm.png" text="Farm"/>
                    <NavigationButton disabled={navBarLoading || farm.none} path="/staff" imagePath="./staff.png" text="Staff"/>
                    <NavigationButton disabled={navBarLoading || farm.none} path="/preferences" imagePath="./preferences.png" text="Preferences"/>
                </div>
                <Separator className="bg-indigo-100"/>
                <div className="hidden md:flex flex-col">
                    <p className="text-[#205083]">Parameters</p>
                    <NavigationButton disabled={navBarLoading || farm.none} path="/parameter/temperature" text="Temperature" className="text-sm hidden md:flex"/>
                    <NavigationButton disabled={navBarLoading || farm.none} path="/parameter/salinity" text="Salinity" className="text-sm hidden md:flex"/>
                    <NavigationButton disabled={navBarLoading || farm.none} path="/parameter/do" text="Dissolved Oxygen" className="text-sm hidden md:flex"/>
                    <NavigationButton disabled={navBarLoading || farm.none} path="/parameter/ph" text="pH Level" className="text-sm hidden md:flex"/>
                    <NavigationButton disabled={navBarLoading || farm.none} path="/parameter/ammonia" text="Ammonia" className="text-sm hidden md:flex"/>
                </div>
                <div className="absolute bottom-[28px] left-1/2 -translate-x-1/2 hidden md:flex flex-col text-center text-sm h-fit text-[#205083]">
                    <p>Ternary Operators</p>
                    <p>Capstone Project 2023-2024</p>
                </div>
            </div>
            <div className="flex-1 flex-grow flex flex-col">
                <div className="flex-grow max-h-[54px] bg-white flex flex-row items-center justify-between px-[24px]">
                    { !farm.none ?<div className="flex flex-row items-center space-x-[20px] transition-all">
                        {farm.name ? 
                        <h5 className="text-blue-800 font-bold">
                            {farm.name}
                        </h5> : <div className="w-[80px] h-[32px] bg-gray-500 animate-pulse"></div>}
                        <Separator orientation="vertical" className="bg-indigo-100 h-7"/>
                        <p className=" text-[12px] text-neutral-500">{nav}</p>
                    </div>
                    : <div>No Farm</div>
                    }
                    <div className="flex flex-row items-center justify-end space-x-[20px]">
                        <Notifications disabled={navBarLoading || farm.none} />
                        <Separator className="h-7 bg-indigo-100" orientation="vertical"/>
                        <Account disabled={farm.none} setNavBarLoading={setNavBarLoading} />
                    </div>
                </div>
                <ScrollArea className="flex-grow ">
                    {children}
                </ScrollArea>
            </div>
        </div>
    )
}