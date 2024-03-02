"use client";

import { useAuthStore } from "@/store/authStore";
import { usePathname } from "next/navigation";
import { ResizableHandle, ResizablePanel, ResizablePanelGroup } from "@/components/ui/resizable";
import { useState } from "react";

interface NavigationBarProps {
    children?: React.ReactNode;
};

export default function NavigationBar ({ children }: NavigationBarProps ): React.ReactNode {
    const path = usePathname();
    const [ collapsed, setCollapsed ] = useState(false);
    const { lastname, firstname } = useAuthStore();

    if (["/signin", "/"].includes(path)) {
        return <>{children}</>;
    }

    return (
        <div className="min-h-screen min-w-full flex flex-row">
            <div className="transition-all max-w-[90px] md:max-w-[316px] flex-1 bg-white">
            </div>
            <div className="flex-1 flex-grow flex flex-col">
                <div className="flex-grow max-h-[54px] bg-white">
                    Test
                </div>
            </div>
        </div>
    )
}