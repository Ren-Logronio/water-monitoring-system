"use client";

import { DropdownMenu, DropdownMenuContent, DropdownMenuLabel, DropdownMenuSeparator, DropdownMenuTrigger } from "@/components/ui/dropdown-menu";
import { Button } from "../ui/button";
import { useEffect, useState } from "react";
import { format, set } from "date-fns";
import axios from "axios";
import { usePathname } from "next/navigation";
import { pathIsSignIn } from "@/utils/PathChecker";
import { NinetyRing } from "react-svg-spinners";

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
        }, 10000);
        return () => clearInterval(updateCount);
    }, [])

    useEffect(() => {
        console.log(notificationCount);
    }, [notificationCount]);

    const handleOpen = (open: boolean) => {
        setOpen(open);
        if (open) {
            if (userNotifications.length) return;
            setLoading(true);
        } else {
            clearInterval(poller);
        }
    }

    const handleNotificationToggle = (value: "reading"|"all") => {
        return () => {
            setNotificationToggle(value);
        }
    } 

    useEffect(() => {
        console.log("NOTIFICATION TOGGLE", notificationToggle);
        if (!notificationToggle || !open) return;
        setLoading(true);
        if (notificationToggle === "all") {
            console.log("fetching notification");
            axios.get("/api/notification/reading")
                .then((response) => {
                    console.log(response.data);
                    setReadingNotification(response.data.results);
                    axios.get("/api/notification")
                        .then((response) => {
                            console.log(response.data);
                            const parsedNotifications = response.data.results.map((notification: any) => {
                                return {
                                    ...notification,
                                    title: notification.action === "WARN" ? "Warning" : notification.action === "ALRT" ? "Alert" : "Information",
                                    action: notification.action,
                                    message: notification.message,
                                    dateIssued: format(notification.issued_at, "MMM dd, yyyy"),
                                }
                            });
                            setUserNotifications(parsedNotifications);
                        }).catch((error) => {
                            console.error(error);
                        }).finally(() => {
                            setLoading(false);
                        });
                })
                .catch((error) => {
                    console.error(error);
                });
        } else {
            axios.get("/api/notification/reading")
                .then((response) => {
                    console.log(response.data);
                    setReadingNotification(response.data.results);
                })
                .catch((error) => {
                    console.error(error);
                }).finally(() => {
                    console.log("TAG UNLOAD");
                    setLoading(false);
                });
        }
    }, [notificationToggle, open]);

    useEffect(() => {
        console.log("READING NOTIFICATIONS", readingNotification);
        console.log("LOADING STATE", loading)
    }, [readingNotification]);

    const handleMarkReadingNotificationAsRead = (reading_notification_id: number) => {
        return () => axios.patch("/api/notification/reading", { reading_notification_id }).then((response: any) => {
            setReadingNotification([
                ...readingNotification.filter((notification: any) => notification.reading_notification_id !== reading_notification_id), 
                ...([readingNotification.find((notification: any) => notification.reading_notification_id === reading_notification_id)].map((notification: any) => ({...notification, isRead: true, read_at: new Date()})))
            ]);
            setNotificationCount(notificationCount - 1);
        });
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
            <DropdownMenuContent className="min-w-[416px] max-w-[416px]">
                <DropdownMenuLabel className="text-center">Notifications</DropdownMenuLabel>
                <div className="flex flex-row pl-4 mb-2">
                    <Button variant="ghost" disabled={notificationToggle === "reading"} onClick={handleNotificationToggle("reading")} className="text-[#205083] disabled:bg-[#DEEAF7] !disabled:text-[#205083] disabled:opacity-100`">Readings</Button>
                    <Button variant="ghost" disabled={notificationToggle === "all"} onClick={handleNotificationToggle("all")} className="text-[#205083] disabled:bg-[#DEEAF7] !disabled:text-[#205083] disabled:opacity-100`">All</Button>
                </div>
                {
                    loading &&
                    <div className="min-h-[200px] flex flex-col items-center justify-center text-slate-500">
                        <NinetyRing />
                        <p className="text-center text-sm py-2">Loading Notifications...</p>
                    </div>
                }
                {
                    !loading && <>
                    <DropdownMenuSeparator></DropdownMenuSeparator>
                    <div className="text-sm text-center">Reading Notifications</div>
                    {
                        readingNotification.map((notification: any, index: any) => <a 
                            onClick={handleMarkReadingNotificationAsRead(notification.reading_notification_id)}
                            href={`/reading?notification_id=${notification.reading_notification_id}`} 
                            target="_blank" key={index} 
                            className={`${notification.isRead && "opacity-50"} flex flex-row items-center justify-between transition-all hover:bg-slate-50 p-2 ${notification.action === "DANGER" && "bg-red-50"}`}>
                            <div className="flex flex-row items-center">
                                    <div className="flex min-w-6">
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
                                    </div>
                                    <div className="flex flex-col ml-2">
                                        <p className="text-sm">
                                            {notification.pond_name && 
                                                (notification.pond_name[notification.pond_name.length - 1].toLowerCase() === "s" ? 
                                                `${notification.pond_name}'` : `${notification.pond_name}'s`)
                                            } {notification.parameter_name} level
                                        </p>
                                        <p className="text-xs">
                                            The reading {Number(notification.value)} {notification.unit} recorded at {format(notification.recorded_at, "MMM dd, yyyy")}, {format(notification.recorded_at, "h:mm a")} has {notification.type === "GT" ? "exceeded" : notification.type === "LT" ? "fallen below" : "reached the threshold value of"} {Number(notification.target)} {notification.unit}
                                        </p>
                                    </div>
                            </div>
                            <p className="text-xs text-center min-w-[90px]">{format(notification.issued_at, "MMM dd, yyyy")}, {format(notification.issued_at, "h:mm a")}</p>
                        </a>)
                    }
                    {
                        !readingNotification.length && <div className="min-h-[200px] flex flex-col items-center justify-center text-slate-500">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-6 h-6">
                            <path strokeLinecap="round" strokeLinejoin="round" d="m20.25 7.5-.625 10.632a2.25 2.25 0 0 1-2.247 2.118H6.622a2.25 2.25 0 0 1-2.247-2.118L3.75 7.5m6 4.125 2.25 2.25m0 0 2.25 2.25M12 13.875l2.25-2.25M12 13.875l-2.25 2.25M3.375 7.5h17.25c.621 0 1.125-.504 1.125-1.125v-1.5c0-.621-.504-1.125-1.125-1.125H3.375c-.621 0-1.125.504-1.125 1.125v1.5c0 .621.504 1.125 1.125 1.125Z" />
                        </svg>
                        <p className="text-center text-sm py-2">No notifications</p>
                    </div>
                    }
                    </>
                }
                {
                    !loading && notificationToggle === "all" && userNotifications.length > 0 && <>
                    <DropdownMenuSeparator></DropdownMenuSeparator>
                    <div className="text-sm text-center">Other notifications</div>
                    <div className="flex flex-row justify-end">
                        <Button variant="ghost" className="text-[#205083] text-xs">Mark all as read</Button>
                    </div>
                    {userNotifications.map((notification: any, index: any) => {
                        return (
                            <a key={index} className={`flex flex-row items-center justify-between transition-all hover:bg-slate-50 p-2 ${notification.action === "DANGER" && "bg-red-50"}`}>
                                <div className="flex flex-row items-center">
                                    <div className="flex min-w-2">
                                        <div className={` size-2 rounded-full ${notification.action === "INFO" && "bg-slate-500"} ${ notification.action === "WARN" && "bg-red-600" } ${ notification.action === "ALRT" && "bg-yellow-500"}`}></div>
                                    </div>
                                    <div className="flex flex-col ml-2">
                                        <p className="text-xs">{notification.message}</p>
                                    </div>
                                </div>
                                <p className="text-xs text-center min-w-[90px]">{notification.dateIssued}</p>
                            </a>
                        )
                    })}
                    </>
                }
            </DropdownMenuContent>
        </DropdownMenu>
    )
}