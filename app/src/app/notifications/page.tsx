"use client";

import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import useFarm from "@/hooks/useFarm";
import roundToSecondDecimal from "@/utils/RoundToNDecimals";
import axios from "axios";
import { set } from "date-fns";
import moment from "moment";
import Link from "next/link";
import { useRouter, useSearchParams } from "next/navigation";
import { useEffect, useState } from "react";
import { Area, AreaChart, CartesianGrid, Line, LineChart, ReferenceArea, ResponsiveContainer, Tooltip, XAxis, YAxis } from "recharts";

export default function NotificationLogs(){
    const { selectedFarm } = useFarm();
    const [notifications, setNotifications] = useState<any[]>([]);
    const [waterQualityReadings, setWaterQualityReadings] = useState<any[]>([]);
    const [currentPond, setCurrentPond] = useState({} as any);
    const [ponds, setPonds] = useState<any[]>([]);
    const [loading, setLoading] = useState(true);
    const searchParams = useSearchParams();
    const router = useRouter();

    useEffect(() => {
        if (!Object.keys(selectedFarm).length) return;
        setLoading(true);
        axios.get(`/api/pond${selectedFarm?.farm_id && `?farmid=${selectedFarm?.farm_id}`}`).then(response => {
            setPonds(response.data.results);
            setLoading(false);
            if (searchParams.has("pond_id")) {
                console.log("TEST CURRENT POND", response.data.results.find((pond: any) => pond.pond_id === Number(searchParams.get("pond_id"))))
                setCurrentPond(response.data.results.find((pond: any) => pond.pond_id === Number(searchParams.get("pond_id"))));
                axios.get(`/api/pond/current-readings?pond_id=${searchParams.get("pond_id")}`).then(response => {
                    setWaterQualityReadings(response.data.results.sort((a: any,b: any) => moment(a.timestamp).diff(moment(b.timestamp))));
                }).catch(error => {
                    console.error(error);
                }); 
            } else {
                setCurrentPond(response.data.results[0]);
                axios.get(`/api/pond/current-readings?pond_id=${response.data.results[0].pond_id}`).then(response => {
                    setWaterQualityReadings(response.data.results.sort((a: any,b: any) => moment(a.timestamp).diff(moment(b.timestamp))));
                }).catch(error => {
                    console.error(error);
                });
            }
            axios.get("/api/notification/water-quality").then(({ data }) => {
                data?.results && setNotifications(data.results);
            }).catch(console.error);
        }).catch(console.error);
    }, [selectedFarm])

    return <div className="flex flex-col p-4 w-full space-y-3">
        {!loading && currentPond && Object.keys(currentPond).length && <><Select value={String(currentPond.pond_id)} onValueChange={(value: any) => {setCurrentPond(ponds.find((pond:any) => pond.pond_id === Number(value)))}}>
            <SelectTrigger className="w-[180px] border-2 border-orange-300 bg-orange-50 focus-visible:ring-blue-200/40 focus-visible:ring-4 shadow-none rounded-2xl">
                <SelectValue placeholder="Select Pond" />
            </SelectTrigger>
            <SelectContent>
                {
                    ponds.map(
                        (pond: any) => <SelectItem key={pond.pond_id} value={String(pond.pond_id)}>{pond.name}</SelectItem>
                    )
                }
                {/* <SelectItem value="light">Light</SelectItem> */}
            </SelectContent>
        </Select>
        <div className="flex flex-col">
            <p className="m-0 font-semibold text-[16px] text-center">Water Quality Graph</p>
            <ResponsiveContainer width="100%" height="25%" className="p-3 min-h-[300px]">
                <LineChart data={waterQualityReadings.map(
                    (reading: any) => ({ date: moment(reading.timestamp).format("MMM DD, yyyy - hh:mm a"), ["Water Quality Index"]: roundToSecondDecimal(reading.wqi * 100) })
                )}
                    margin={{ top: 20, right: 30, left: 0, bottom: 0 }}>
                    <XAxis dataKey="date" />
                    <YAxis dataKey="Water Quality Index" min={0} max={100} />
                    <CartesianGrid strokeDasharray="3 3" />
                    <Tooltip />
                    <Line type="monotone" dataKey="Water Quality Index" label="Water Quality Index" stroke="#8884d8" fill="#8884d8" />
                    <ReferenceArea y1={25} y2={50} fill="orange" fillOpacity={0.1} stroke="" />
                    <ReferenceArea y1={0} y2={25} fill="red" fillOpacity={0.1} stroke="" />
                    {
                        notifications.map((notification: any) => <>
                            <ReferenceArea key={notification.notification_id} 
                                x1={waterQualityReadings.indexOf(waterQualityReadings.find(reading => moment(reading.timestamp).isSame(moment(notification.date_issued), "minutes")))} 
                                x2={notification.is_resolved ? waterQualityReadings.indexOf(waterQualityReadings.find(reading => moment(reading.timestamp).isSame(moment(notification.date_resolved)), "minutes")) : waterQualityReadings.length - 1}
                                fill={notification.water_quality === "POOR" ? "orange" : "red"} 
                                fillOpacity={searchParams.has("notification_id") && Number(searchParams.get("notification_id")) === notification.notification_id ? 0.5 : 0.1}
                                stroke="" />
                        </>)
                    }
                </LineChart>
            </ResponsiveContainer>
        </div>
        <Table className="mt-2 max-h-[100px]">
            <TableHeader>
                <TableRow>
                    <TableHead>#</TableHead>
                    <TableHead>Notification</TableHead>
                    <TableHead>Date Issued</TableHead>
                    <TableHead>Time Issued</TableHead>
                    <TableHead>Status</TableHead>
                </TableRow>
            </TableHeader>
            <TableBody>
                {
                    !notifications?.length && <TableRow>
                        <TableCell className="text-center" colSpan={5}>No notifications found</TableCell>
                    </TableRow>
                }
                {
                    notifications.filter(notification => notification.pond_id === currentPond.pond_id).map((notification: any, index: number) => {
                        return <TableRow onClick={() => router.push(`/notifications?notification_id=${notification.notification_id}`)} key={notification.notification_id} className={`cursor-pointer ${searchParams.has("notification_id") && Number(searchParams.get("notification_id")) === notification.notification_id && "bg-orange-200"}`}>
                            <TableCell>{index + 1}</TableCell>
                            <TableCell>{notification?.name}&apos;s Water Quality - <span className={`font-semibold ${notification.water_quality === "POOR" ? "text-orange-500" : notification.water_quality === "VERY POOR" ? "text-red-500" : ""}`}>{notification?.water_quality}</span></TableCell>
                            <TableCell>{moment(notification.date_issued).format("MMM DD, yyyy")}</TableCell>
                            <TableCell>{moment(notification.date_issued).format("hh:mm A")}</TableCell>
                            <TableCell className={`${notification.is_resolved ? "text-green-700" : "text-red-500"} font-semibold`}
                            >{notification.is_resolved ? `Resolved at ${moment(notification.date_resolved).format("MMM DD, yyyy - hh:mm A")}` : "Unresolved"}</TableCell>
                        </TableRow>
                    })
                }
            </TableBody>
        </Table></>
        }
    </div>
}