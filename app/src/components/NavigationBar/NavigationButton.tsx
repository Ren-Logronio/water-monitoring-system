/* eslint-disable @next/next/no-img-element */
/* eslint-disable jsx-a11y/alt-text */

import { usePathname, useRouter } from "next/navigation";
import { Button } from "../ui/button";
import { set } from "date-fns";

export default function NavigationButton({ disabled, path, imagePath, text, shortcut, className }: Readonly<{ disabled: boolean, path: string, imagePath?: string, text?: string, shortcut?: string, className?: string }>) {
    const pathName = usePathname();
    const router = useRouter();

    // replace the current path with the new path
    const handleClick = () => {
        router.replace(path);
    };

    return (
        <Button onClick={() => handleClick()} disabled={disabled} variant="ghost"
            className={`select-none font-semibold md:justify-start transition-all text-start text-md text-[14px] size-[65px] mx-auto md:mx-0 md:size-auto text-[#205083] hover:text-[#205083] hover:bg-[#DEEAF7] space-x-1 ${pathName.startsWith(path) && "bg-[#DEEAF7] text-[#205083]"} disabled:opacity-50`}>
            {!!imagePath && <img src={imagePath} className="h-[20px] aspect-auto px-1" />}
            {!imagePath && <p className="flex md:hidden text-xs font-semibold">{shortcut}</p>}
            <p className="transition-all hidden md:block">{text || ""}</p>
        </Button>
    );
}