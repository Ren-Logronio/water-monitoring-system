"use client";

import { DropdownMenu, DropdownMenuContent, DropdownMenuLabel, DropdownMenuSeparator, DropdownMenuTrigger } from "@/components/ui/dropdown-menu";
import { Button } from "../ui/button";
import { useEffect, useState } from "react";
import { format } from "date-fns";
import axios from "axios";
import { usePathname } from "next/navigation";
import { pathIsSignIn } from "@/utils/PathChecker";
import { NinetyRing } from "react-svg-spinners";

export default function Notifications({ disabled = false }: Readonly<{ disabled: boolean }>) {
    const path = usePathname();
    const [notificationCount, setNotificationCount] = useState<number>(0);
    const [loading, setLoading] = useState<boolean>(false);
    const [active, setActive] = useState<boolean>(false);
    const [poller, setPoller] = useState<any>(null);
    const [userNotifications, setUserNotifications] = useState<any>([]);
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
        if (!active) {
            setUserNotifications([]);
        };
    }, [active]);

    useEffect(() => {
        if (pathIsSignIn(path)) { setNotificationCount(0); return; };
        axios.get("/api/notification/count").then(response => {
            console.log("Notification Count:", response.data.results);
            if (response.data.count <= 0) {
                setNotificationCount(0);
                return;
            };
            setNotificationCount(response.data.count);
        }).catch(error => {
            console.error(error);
        });
        const updateCount = setInterval(() => {
            axios.get("/api/notification/count").then(response => {
                if (response.data.count <= 0) {
                    setNotificationCount(0);
                    return;
                };
                setNotificationCount(response.data.count);
            }).catch(error => {
                console.error(error);
            });
        }, 60000);
        return () => clearInterval(updateCount);
    }, [])

    useEffect(() => {
        console.log(notificationCount);
    }, [notificationCount]);

    const handleOpen = (open: boolean) => {
        if (open) {
            if (userNotifications.length) return;
            setLoading(true);
            const fetchNotifications = () => {
                console.log("fetching notification");
                axios.get("/api/notification")
                    .then((response) => {
                        console.log(response.data);
                        const parsedNotifications = response.data.results.map((notification: any) => {
                            return {
                                title: notification.action === "WARN" ? "Warning" : notification.action === "ALRT" ? "Alert" : "Information",
                                action: notification.action,
                                message: notification.message,
                                dateIssued: format(notification.issued_at, "MMM dd, yyyy"),
                            }
                        });
                        setUserNotifications(parsedNotifications);
                    })
                    .catch((error) => {
                        console.error(error);
                    }).finally(() => {
                        setLoading(false);
                    });
            };
            fetchNotifications();
            const poller = setInterval(fetchNotifications, 10000);
            setPoller(poller);
        } else {
            clearInterval(poller);
        }
    }

    const handleNotificationToggle = (value: "reading"|"all") => {
        return () => {
            setNotificationToggle(value);
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
            <DropdownMenuContent className="min-w-[416px]">
                <DropdownMenuLabel className="text-center">Notifications</DropdownMenuLabel>
                <div className="flex flex-row pl-4">
                    <Button variant={ notificationToggle === "reading" ? "outline" : "ghost" } onClick={handleNotificationToggle("reading")}>Readings</Button>
                    <Button variant={ notificationToggle === "all" ? "outline" : "ghost" } onClick={handleNotificationToggle("all")}>All</Button>
                </div>
                {
                    loading &&
                    <div className="min-h-[200px] flex flex-col items-center justify-center text-slate-500">
                        <NinetyRing />
                        <p className="text-center text-sm py-2">Loading Notifications...</p>
                    </div>
                }
                {/* {
                    !loading && !userNotifications.length &&
                    <div className="min-h-[200px] flex flex-col items-center justify-center text-slate-500">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-6 h-6">
                            <path strokeLinecap="round" strokeLinejoin="round" d="m20.25 7.5-.625 10.632a2.25 2.25 0 0 1-2.247 2.118H6.622a2.25 2.25 0 0 1-2.247-2.118L3.75 7.5m6 4.125 2.25 2.25m0 0 2.25 2.25M12 13.875l2.25-2.25M12 13.875l-2.25 2.25M3.375 7.5h17.25c.621 0 1.125-.504 1.125-1.125v-1.5c0-.621-.504-1.125-1.125-1.125H3.375c-.621 0-1.125.504-1.125 1.125v1.5c0 .621.504 1.125 1.125 1.125Z" />
                        </svg>
                        <p className="text-center text-sm py-2">No notifications</p>
                    </div>
                } */}
                {
                    !loading && userNotifications.map((notification: any, index: any) => {
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
                                        notification.action === "ALRT" &&
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
    )
}