"use client";

import { useAuthStore } from "@/store/authStore";
import { usePathname } from "next/navigation";
import { useEffect, useState } from "react";
import { ScrollArea } from "../ui/scroll-area";
import { Button } from "../ui/button";
import { DropdownMenu, DropdownMenuContent, DropdownMenuTrigger } from "../ui/dropdown-menu";

interface NavigationBarProps {
    children?: React.ReactNode;
};

export default function NavigationBar ({ children }: NavigationBarProps ): React.ReactNode {
    const path = usePathname();
    const [ collapsed, setCollapsed ] = useState(false);
    const [ lastname, setLastname ] = useState("");
    const [ firstname, setFirstname ] = useState("");

    const notifications: any = [
        // {
        //     title: "Account Expiry",
        //     action: "WARN",
        //     message: "Your account is about to expire in 7 days",
        //     target: "/parameter/temperature",
        //     dateIssued: "Feb 12, 2022"
        // },
        // {
        //     title: "Account Expiry",
        //     action: "DANGER",
        //     message: "Your account has expired",
        //     target: "/parameter/temperature",
        //     dateIssued: "Feb 13, 2022"
        // },
        // {
        //     title: "Account Created",
        //     action: "INFO",
        //     target: "/parameter/temperature",
        //     message: "Your account has been created",
        //     dateIssued: "Feb 10, 2022"
        // }
    ]

    if (["/signin", "/"].includes(path)) {
        return <>{children}</>;
    }

    useEffect(() => {
        const { firstname, lastname } = { firstname: sessionStorage.getItem("firstname"), lastname: sessionStorage.getItem("lastname")};
        setFirstname(firstname || "");
        setLastname(lastname || "");
    }, []);

    return (
        <div className="min-h-screen min-w-full flex flex-row">
            <div className="transition-all max-w-[90px] md:max-w-[316px] flex-1 bg-white">
                Left
            </div>
            <div className="flex-1 flex-grow flex flex-col">
                <div className="flex-grow max-h-[54px] bg-white flex flex-row items-center justify-between px-[24px]">
                    <div>Dashboard</div>
                    <div>
                        {firstname && lastname && 
                        <>
                            <DropdownMenu>
                                <DropdownMenuTrigger asChild>
                                    <Button variant="ghost" className=" align-middle px-2 mr-2">
                                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-6 h-6 transition-all hover:rotate-6">
                                            <path strokeLinecap="round" strokeLinejoin="round" d="M14.857 17.082a23.848 23.848 0 0 0 5.454-1.31A8.967 8.967 0 0 1 18 9.75V9A6 6 0 0 0 6 9v.75a8.967 8.967 0 0 1-2.312 6.022c1.733.64 3.56 1.085 5.455 1.31m5.714 0a24.255 24.255 0 0 1-5.714 0m5.714 0a3 3 0 1 1-5.714 0" />
                                        </svg>
                                    </Button>
                                </DropdownMenuTrigger>
                                <DropdownMenuContent className="min-w-[416px]">
                                    <p className="text-center text-sm py-2 border-b border-accent">Notifications</p>
                                    {
                                        !notifications.length &&
                                        <div className="min-h-[200px] flex flex-col items-center justify-center text-slate-500">
                                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-6 h-6">
                                                <path strokeLinecap="round" strokeLinejoin="round" d="m20.25 7.5-.625 10.632a2.25 2.25 0 0 1-2.247 2.118H6.622a2.25 2.25 0 0 1-2.247-2.118L3.75 7.5m6 4.125 2.25 2.25m0 0 2.25 2.25M12 13.875l2.25-2.25M12 13.875l-2.25 2.25M3.375 7.5h17.25c.621 0 1.125-.504 1.125-1.125v-1.5c0-.621-.504-1.125-1.125-1.125H3.375c-.621 0-1.125.504-1.125 1.125v1.5c0 .621.504 1.125 1.125 1.125Z" />
                                            </svg>
                                            <p className="text-center text-sm py-2">No notifications</p>
                                        </div>
                                        
                                    }
                                    {
                                        !!notifications.length && notifications.map((notification: any, index: any) => {
                                            return (
                                                <a href={notification.target} key={index} className={`flex flex-row items-center justify-between transition-all hover:bg-slate-50 p-2 ${notification.action === "DANGER" && "bg-red-50"}`}>
                                                    <div className="flex flex-row items-center">
                                                        {
                                                            notification.action === "WARN" &&
                                                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-6 h-6 text-yellow-500">
                                                                <path strokeLinecap="round" strokeLinejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126ZM12 15.75h.007v.008H12v-.008Z" />
                                                            </svg>
                                                        }
                                                        {
                                                            notification.action === "DANGER" &&
                                                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-6 h-6 text-red-500">
                                                                <path strokeLinecap="round" strokeLinejoin="round" d="M12 9v3.75m9-.75a9 9 0 1 1-18 0 9 9 0 0 1 18 0Zm-9 3.75h.008v.008H12v-.008Z" />
                                                            </svg>
                                                        }
                                                        {
                                                            notification.action === "INFO" &&
                                                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-6 h-6 text-slate-500">
                                                                <path strokeLinecap="round" strokeLinejoin="round" d="m11.25 11.25.041-.02a.75.75 0 0 1 1.063.852l-.708 2.836a.75.75 0 0 0 1.063.853l.041-.021M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Zm-9-3.75h.008v.008H12V8.25Z" />
                                                            </svg>
                                                        }
                                                        <div className="flex flex-col ml-2">
                                                            <p className="text-sm font-semibold">{notification.title}</p>
                                                            <p className="text-xs">{notification.message}</p>
                                                        </div>
                                                    </div>
                                                    <p className="text-xs">{notification.dateIssued}</p>
                                                </a>
                                            )
                                        })
                                    }
                                </DropdownMenuContent>
                            </DropdownMenu>
                            <Button variant="ghost" className=" align-middle px-2">
                                <p className="hidden sm:block mr-2">{firstname?.toUpperCase()}, {lastname?.toUpperCase()}</p>
                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" fill="currentColor" className="w-4 h-4">
                                    <path fillRule="evenodd" d="M4.22 6.22a.75.75 0 0 1 1.06 0L8 8.94l2.72-2.72a.75.75 0 1 1 1.06 1.06l-3.25 3.25a.75.75 0 0 1-1.06 0L4.22 7.28a.75.75 0 0 1 0-1.06Z" clipRule="evenodd" />
                                </svg>
                            </Button>
                        </>
                        }
                        {!firstname && !lastname && <div className="min-h-[28px] min-w-[160px] bg-[#EBEBEB] animate-pulse"></div>}
                    </div>
                </div>
                <ScrollArea className="flex-grow">
                    {children}
                </ScrollArea>
            </div>
        </div>
    )
}