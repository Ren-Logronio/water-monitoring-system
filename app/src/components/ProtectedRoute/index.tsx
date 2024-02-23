"use client";

import Cookies from "js-cookie";
import { usePathname } from "next/navigation";

export default function ProtectedRoute({ children }: Readonly<{ children: React.ReactNode; }>) {
    const pathname = usePathname()

    if (Cookies.get('token') || pathname === "/") {
        return <>{children}</>;
    }

    return <div>Not authorized</div>;
}