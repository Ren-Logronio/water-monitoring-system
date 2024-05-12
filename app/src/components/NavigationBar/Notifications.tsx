"use client";

import { DropdownMenu, DropdownMenuContent, DropdownMenuLabel, DropdownMenuSeparator, DropdownMenuTrigger } from "@/components/ui/dropdown-menu";
import { Button } from "../ui/button";
import { useEffect, useState } from "react";
import { format, set } from "date-fns";
import axios from "axios";
import { usePathname } from "next/navigation";
import { pathIsSignIn } from "@/utils/PathChecker";
import { NinetyRing } from "react-svg-spinners";
import moment from "moment-timezone";
import Link from "next/link";
import Image from "next/image";

export default function Notifications({ disabled = false }: Readonly<{ disabled: boolean }>) {
    const path = usePathname();
    const [notificationCount, setNotificationCount] = useState<number>(0);
    const [open, setOpen] = useState<boolean>(false);
    const [loading, setLoading] = useState<boolean>(false);
    const [active, setActive] = useState<boolean>(false);
    const [poller, setPoller] = useState<any>(null);
    const [userNotifications, setUserNotifications] = useState<any>([]);
    const [readingNotification, setReadingNotification] = useState<any>([]);
    const [notificationToggle, setNotificationToggle] = useState<"reading"|"all">("reading");

    useEffect(() => {
        if (pathIsSignIn(path)) {
            console.log("Notif fetch disabled");
            setActive(false);
            clearInterval(poller);
        } else {
            console.log("Notif fetch enabled");
            setActive(true);
        };
    }, [path]);

    useEffect(() => {
        const setIntervalId = setInterval(() => {
            axios.get("/api/notification/water-quality").then(({ data }) => {
                setUserNotifications(data.results);
                setNotificationCount(data.results.filter((result: any) => !result.is_resolved).length);
                setLoading(false);
            }).catch(console.error);
        }, 5000);
        return () => clearInterval(setIntervalId);
    }, []);

    const handleOpen = (open: boolean) => {
        setOpen(open);
        if (open) {
            if (userNotifications.length) return;
            setLoading(true);
        } else {
            clearInterval(poller);
        }
    }

    return (
        <DropdownMenu onOpenChange={handleOpen}>
            <DropdownMenuTrigger asChild>
                <Button disabled={!active || disabled} variant="outline" className="relative text-blue-800 border-blue-800 align-middle px-2">
                    {notificationCount > 0 && <div className="absolute top-0 right-0 size-[16px] translate-x-1/2 -translate-y-1/2 rounded-full bg-[#FF9B42] text-white font-semibold text-xs">{notificationCount}</div>}
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-6 h-6 transition-all hover:rotate-6">
                        <path strokeLinecap="round" strokeLinejoin="round" d="M14.857 17.082a23.848 23.848 0 0 0 5.454-1.31A8.967 8.967 0 0 1 18 9.75V9A6 6 0 0 0 6 9v.75a8.967 8.967 0 0 1-2.312 6.022c1.733.64 3.56 1.085 5.455 1.31m5.714 0a24.255 24.255 0 0 1-5.714 0m5.714 0a3 3 0 1 1-5.714 0" />
                    </svg>
                </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent className="md:min-w-[400px] lg:min-w-[400px] max-w-[400px] mr-6">
                <DropdownMenuLabel className="text-center">Notifications</DropdownMenuLabel>
                <DropdownMenuSeparator />
                {userNotifications.map((notification: any) => <>
                    <Link href={``} className="flex flex-row justify-start space-x-2 items-center p-1 hover:bg-gray-50">
                        <div className="flex justify-center items-center">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-6 h-6">
                                    <path strokeLinecap="round" strokeLinejoin="round" d="M12 9v3.75m9-.75a9 9 0 1 1-18 0 9 9 0 0 1 18 0Zm-9 3.75h.008v.008H12v-.008Z" />
                                </svg>
                        </div>
                        <div className="flex flex-col">
                            
                            <div className="flex flex-col  w-full p-1">
                                <p className="font-medium text-sm">Water Quality is <b>{notification?.water_quality}</b></p>
                                <p>Status - {notification.is_resolved ? "Resolved" : "Unresolved"}</p>
                                <p className="text-xs text-gray-500">{moment(notification.date_issued).from(moment())}</p>
                                <p className="text-xs text-gray-500">{moment(notification.date_issued).format("MMM DD, yyyy - hh:mm a")}</p>
                            </div>
                        </div>
                        <></>
                    </Link>
                </>)}
            </DropdownMenuContent>
        </DropdownMenu>
    )
}