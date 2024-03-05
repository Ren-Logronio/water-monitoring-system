"use client";

import { useRouter, useSearchParams } from "next/navigation";
import { useEffect } from "react";

export default function Redirect() {
    const router = useRouter();
    const searchParams = useSearchParams();

    useEffect(() => {
        if (searchParams.get('w')) { router.replace(`${searchParams.get('w')}`); return; };
    })

    return (
        <div>
            <h1>Redirecting...</h1>
        </div>
    );
}