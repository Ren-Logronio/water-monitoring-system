"use client";

import { useRouter } from "next/navigation";
import { useEffect } from "react";

export default function Pdf() {
    const router = useRouter()
    useEffect(() => {
        router.replace("/dashboard");
    }, []);
    return <></>
}