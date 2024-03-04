import { usePathname, useRouter } from "next/navigation";
import { Button } from "../ui/button";

export default function NavigationButton({ disabled, path, imagePath, text, shortcut, className }: Readonly<{ disabled: boolean, path: string, imagePath?: string, text?: string, shortcut?: string, className?: string }>) {
    const pathName = usePathname();
    const router = useRouter();

    const handleClick = () => {
        router.replace(path);
    };

    return (
        <Button onClick={handleClick} disabled={pathName.startsWith(path) || disabled} variant="ghost" className={`md:justify-start transition-all text-start text-md size-[65px] mx-auto md:mx-0 md:size-auto text-[#205083] hover:text-[#205083] hover:bg-[#DEEAF7] space-x-1 ${className && className}`}>
            {!!imagePath && <img src={imagePath} className="h-[20px] aspect-auto px-1" />}
            {!imagePath && <p className="flex md:hidden text-xs font-semibold">{shortcut}</p>}
            <p className="transition-all hidden md:block">{text || ""}</p>
        </Button>
    );
}