"use client";

import { useEffect, useState } from "react";
import { DropdownMenu, DropdownMenuContent, DropdownMenuLabel, DropdownMenuSeparator, DropdownMenuTrigger, DropdownMenuGroup, DropdownMenuItem } from "@/components/ui/dropdown-menu";
import { Button } from "../ui/button";
import { usePathname, useRouter } from "next/navigation";
import { NinetyRing } from "react-svg-spinners";

export default function ({ disabled = false, setNavBarLoading }: Readonly<{ disabled: boolean, setNavBarLoading: (bool: boolean) => void }>) {
    const [ userName, setUserName ] = useState({firstname: "", lastname: ""});
    const [ signoutLoading, setSignOutLoading ] = useState(false);
    const router = useRouter();
    const path = usePathname();

    const handleSignout = () => {
        setSignOutLoading(true);
        setNavBarLoading(true);
        setTimeout(() => {
            router.replace("/signin?signout");
            setSignOutLoading(false);
            setNavBarLoading(false);
        }, 2000);
    };

    useEffect(() => {
        const firstname = localStorage.getItem("firstname") || "";
        const lastname = localStorage.getItem("lastname") || "";
        setUserName({firstname, lastname});
    }, [path]);

    return (
        <DropdownMenu>
            <DropdownMenuTrigger asChild>
                <Button disabled={signoutLoading} variant="ghost" className=" align-middle px-2">
                    { signoutLoading ? 
                        <div className="flex flex-row items-center space-x-2">
                            <NinetyRing color="currentColor"/>
                            <p>Signing Out...</p>
                        </div>
                        : !userName.firstname && !userName.lastname ? <>
                            <NinetyRing color="currentColor"/>
                        </>
                        : <>
                            <p className="hidden sm:block mr-2">{userName.firstname?.toUpperCase()}, {userName.lastname?.toUpperCase()}</p>
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" fill="currentColor" className="w-4 h-4">
                                <path fillRule="evenodd" d="M4.22 6.22a.75.75 0 0 1 1.06 0L8 8.94l2.72-2.72a.75.75 0 1 1 1.06 1.06l-3.25 3.25a.75.75 0 0 1-1.06 0L4.22 7.28a.75.75 0 0 1 0-1.06Z" clipRule="evenodd" />
                            </svg>
                        </>
                    }
                </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent className="min-w-56">
                <DropdownMenuLabel className="text-center">Account</DropdownMenuLabel>
                <DropdownMenuSeparator />
                <DropdownMenuGroup>
                    <DropdownMenuItem className=" cursor-pointer" onClick={handleSignout}>
                        Sign out
                    </DropdownMenuItem>
                </DropdownMenuGroup>
            </DropdownMenuContent>
        </DropdownMenu>
    )
}