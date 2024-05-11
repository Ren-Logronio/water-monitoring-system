"use client";

import { DropdownMenu, DropdownMenuContent, DropdownMenuLabel, DropdownMenuSeparator, DropdownMenuTrigger } from "@/components/ui/dropdown-menu";
import { Button } from "../ui/button";
import { useEffect, useState } from "react";
import { format, set } from "date-fns";
import axios from "axios";
import { usePathname } from "next/navigation";
import { pathIsSignIn } from "@/utils/PathChecker";
import { NinetyRing } from "react-svg-spinners";
import moment from "moment";

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
            <DropdownMenuContent className="md:min-w-[400px] lg:min-w-[800px] max-w-[800px] mr-6">
                <DropdownMenuLabel className="text-center">Notifications</DropdownMenuLabel>
                
            </DropdownMenuContent>
        </DropdownMenu>
    )
}