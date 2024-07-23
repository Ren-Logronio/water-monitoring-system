"use client";

import { DropdownMenu, DropdownMenuContent, DropdownMenuLabel, DropdownMenuSeparator, DropdownMenuTrigger } from "@/components/ui/dropdown-menu";
import { Button } from "../ui/button";
import { CSSProperties, useEffect, useMemo, useState } from "react";
import { format, set } from "date-fns";
import axios from "axios";
import { usePathname } from "next/navigation";
import { pathIsSignIn } from "@/utils/PathChecker";
import { NinetyRing } from "react-svg-spinners";
import moment from "moment-timezone";
import Link from "next/link";
import Image from "next/image";
import { useToast } from "../ui/use-toast";
import useAuth from "@/hooks/useAuth";

const toastStyle: CSSProperties = {
    minHeight: "fit",
    minWidth: "400px"
}

export default function Notifications({ disabled = false }: Readonly<{ disabled: boolean }>) {
    const path = usePathname();
    const { toast } = useToast();
    const { addEventListener, removeEventListener } = useAuth();
    const [notificationCount, setNotificationCount] = useState<number>(0);
    const [open, setOpen] = useState<boolean>(false);
    const [loading, setLoading] = useState<boolean>(false);
    const [active, setActive] = useState<boolean>(false);
    const [poller, setPoller] = useState<any>(null);
    const [userNotifications, setUserNotifications] = useState<any[]>([]);
    const [readingNotification, setReadingNotification] = useState<any>([]);
    const [notificationToggle, setNotificationToggle] = useState<"reading" | "all">("reading");
    const [showResolvedNotifications, setShowResolvedNotifications] = useState<boolean>(false);

    // newer comes first
    const unresolvedUserNotifications: any[] = useMemo(() => userNotifications.sort((a, b) => moment(b.date_issued).diff(moment(a.date_issued))).filter((result: any) => !result?.is_resolved), [userNotifications]);
    const resolvedUserNotifications: any[] = useMemo(() => userNotifications.sort((a, b) => moment(b.date_resolved).diff(moment(a.date_resolved))).filter((result: any) => result?.is_resolved), [userNotifications]);

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

    const getNotificationCount = () => {
        return notificationCount;
    }

    useEffect(() => {
        axios.get("/api/notification/water-quality").then(({ data }) => {
            setUserNotifications(data.results);
            if (data?.results?.filter((result: any) => !result.is_resolved).length > 0) {
                toast({
                    title: "Notifications",
                    description: `You have ${data.results.filter((result: any) => !result.is_resolved).length} unresolved notification(s)`,
                    style: toastStyle,
                });
            };
            setNotificationCount(data.results.filter((result: any) => !result.is_resolved).length);
            setLoading(false);
        }).catch(console.error);
        const setIntervalId = setInterval(() => {
            axios.get("/api/notification/water-quality").then(({ data }) => {
                const results: any[] = data.results;
                setUserNotifications(data.results);
                setNotificationCount(prev => {
                    console.log("Compare", { new: data.results.filter((result: any) => !result.is_resolved).length, old: prev });
                    if (results.filter((result: any) => !result.is_resolved).length > prev) {
                        console.log("New Notification");
                        toast({
                            title: "New Notification",
                            description: `You have ${data.results.filter((result: any) => !result.is_resolved).length} new unresolved notification(s)`,
                            variant: "destructive",
                            style: toastStyle,
                        });
                    }
                    if (data.results.filter((result: any) => !result.is_resolved).length < prev) {
                        console.log("Notification Resolved");
                        toast({
                            title: "Notification Resolved",
                            description: `You have ${prev - data.results.filter((result: any) => !result.is_resolved).length} resolved notification(s)`,
                            style: toastStyle,
                        });
                    }
                    return data.results.filter((result: any) => !result.is_resolved).length
                });
                setLoading(false);
            }).catch(console.error);
        }, 5000);
        const signoutEvent = addEventListener("signout", () => {
            clearInterval(setIntervalId);
        });
        return () => {
            removeEventListener(signoutEvent);
            clearInterval(setIntervalId)
        };
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
            <DropdownMenuContent className="md:min-w-[400px] lg:min-w-[600px] max-w-[600px] mr-6 p-2 space-y-4">
                <div>
                    <DropdownMenuLabel className="text-center">Notifications</DropdownMenuLabel>
                    <DropdownMenuSeparator />
                </div>
                {
                    !unresolvedUserNotifications.length && !resolvedUserNotifications.length && <div className="flex flex-row justify-center items-center h-[100px]">
                        <p>No Notifications to Show</p>
                    </div>
                }


                {!!unresolvedUserNotifications.length && <div>
                    <span className="text-[14px] font-medium ml-3">Unresolved Notifications</span>
                    {unresolvedUserNotifications.map((notification: any) => <>
                        <Link href={`/notifications?pond_id=${notification.pond_id}&notification_id=${notification.notification_id}`} className="flex flex-row justify-start space-x-2 items-center p-1 hover:bg-gray-200">
                            <div className="flex justify-center items-center">
                                {
                                    notification?.water_quality === "Poor" &&
                                    <span className=" text-orange-500">
                                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-6 h-6">
                                            <path strokeLinecap="round" strokeLinejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126ZM12 15.75h.007v.008H12v-.008Z" />
                                        </svg>
                                    </span>
                                }
                                {
                                    notification?.water_quality === "Very Poor" && <span className="text-red-800"><svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-6 h-6">
                                        <path strokeLinecap="round" strokeLinejoin="round" d="M12 9v3.75m0-10.036A11.959 11.959 0 0 1 3.598 6 11.99 11.99 0 0 0 3 9.75c0 5.592 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.31-.21-2.57-.598-3.75h-.152c-3.196 0-6.1-1.25-8.25-3.286Zm0 13.036h.008v.008H12v-.008Z" />
                                    </svg></span>
                                }
                            </div>
                            <div className="flex flex-col w-full">

                                <div className="flex flex-col  w-full p-1">
                                    <p className="font-medium text-sm">{notification?.name}&apos;s Water Quality - <b>{notification?.water_quality}</b></p>

                                    <p className="text-xs text-gray-500">{moment(notification.date_issued).from(moment())}</p>
                                    <p className="text-xs text-gray-500">{moment(notification.date_issued).format("MMM DD, yyyy - hh:mm a")}</p>
                                </div>
                            </div>
                            <div className="flex flex-col w-full font-bold text-[14px] pr-4">
                                <p className="text-end text-red-500">{notification.is_resolved ? "Resolved" : "Unresolved"}</p>
                                {notification?.water_quality === "Very Poor" && <p className="text-xs text-end text-red-800">Please take immediate action</p>}
                            </div>
                        </Link>
                    </>)}
                </div>}
                {
                    !!resolvedUserNotifications.length && <div>
                        {!!unresolvedUserNotifications.length && <DropdownMenuSeparator className="mb-2" />}
                        <div className="flex flex-row pr-[40px]">
                            <span className="text-[14px] font-medium ml-3">Resolved Notifications</span>
                            {showResolvedNotifications ? <a onClick={() => setShowResolvedNotifications(false)} className="ml-auto underline cursor-pointer text-[14px]">Hide</a> : <a onClick={() => setShowResolvedNotifications(true)} className="ml-auto underline cursor-pointer text-[14px]">Show</a>}
                        </div>
                        <div className="flex flex-col">
                            {showResolvedNotifications && resolvedUserNotifications.map((notification: any) => <>
                                <Link href={`/notifications?pond_id=${notification.pond_id}&notification_id=${notification.notification_id}`} className="flex flex-row justify-start space-x-2 items-center p-1 hover:bg-gray-200">
                                    <div className="flex justify-center items-center text-green-800">
                                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-6 h-6">
                                            <path strokeLinecap="round" strokeLinejoin="round" d="M9 12.75 11.25 15 15 9.75m-3-7.036A11.959 11.959 0 0 1 3.598 6 11.99 11.99 0 0 0 3 9.749c0 5.592 3.824 10.29 9 11.623 5.176-1.332 9-6.03 9-11.622 0-1.31-.21-2.571-.598-3.751h-.152c-3.196 0-6.1-1.248-8.25-3.285Z" />
                                        </svg>
                                    </div>
                                    <div className="flex flex-col w-full">
                                        <div className="flex flex-col  p-1">
                                            <p className="font-medium text-sm">{notification?.name}&apos;s Water Quality - <b>{notification?.water_quality}</b></p>
                                            <p className="text-xs text-gray-500">{moment(notification.date_issued).from(moment())}</p>
                                            <p className="text-xs text-gray-500">{moment(notification.date_issued).format("MMM DD, yyyy - hh:mm a")}</p>
                                        </div>
                                    </div>
                                    <div className="flex flex-col w-full font-[500] text-end text-[14px] pr-4">
                                        <p className="text-end text-green-800">{notification.is_resolved ? "Resolved" : "Unresolved"}</p>
                                        <p className="text-xs text-green-900">Resolved {moment(notification.date_resolved).from(moment())}</p>
                                        <p className="text-xs text-green-900">{moment(notification.date_resolved).format("MMM DD, yyyy - hh:mm a")}</p>
                                    </div>
                                </Link>
                            </>)}
                        </div>
                    </div>
                }
            </DropdownMenuContent>
        </DropdownMenu>
    )
}