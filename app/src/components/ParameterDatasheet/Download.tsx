import { useParams, useRouter } from "next/navigation";
import { Button } from "../ui/button";
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuLabel, DropdownMenuSeparator, DropdownMenuTrigger } from "../ui/dropdown-menu";
import { useState } from "react";
import { useParameterDatasheetStore } from "@/store/parameterDatasheetStore";
import axios from "axios";
import Link from "next/link";


export default function Download({ pond_id }: { pond_id?: string }) {
    const [loading, setLoading] = useState(false);
    const { rowData } = useParameterDatasheetStore();
    const { parameter } = useParams();
    const router = useRouter();

    const handleDownload = (format: string, all: boolean | undefined = false) => {
        return () => {
            if(format === 'pdf') {
                return;
            }
            setLoading(true);
            axios.get(`/api/download?format=${format}&pond_id=${pond_id}&parameter=${parameter}`, { responseType: "blob" }).then(res => {
                console.log(res);
                const blob = new Blob([res.data], { type: res.headers['content-type'] });
                const url = window.URL.createObjectURL(blob);
                const link = document.createElement('a');
                link.href = url;
                link.setAttribute('download', `downloaded-file.${format === 'spreadsheet' ? 'xlsx' : format}`);
                document.body.appendChild(link);
                link.click();
                link?.parentNode?.removeChild(link);
                window.URL.revokeObjectURL(url);
                setLoading(false);
            }).catch(err => {
                console.log(err);
                setLoading(false);
            });
        }
    }

    return (
        <DropdownMenu>
            <DropdownMenuTrigger asChild>
                <Button disabled={loading || !rowData.length} variant="outline" className="flex flex-row space-x-2">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" className="w-5 h-5">
                        <path fillRule="evenodd" d="M4.5 2A1.5 1.5 0 0 0 3 3.5v13A1.5 1.5 0 0 0 4.5 18h11a1.5 1.5 0 0 0 1.5-1.5V7.621a1.5 1.5 0 0 0-.44-1.06l-4.12-4.122A1.5 1.5 0 0 0 11.378 2H4.5Zm4.75 6.75a.75.75 0 0 1 1.5 0v2.546l.943-1.048a.75.75 0 0 1 1.114 1.004l-2.25 2.5a.75.75 0 0 1-1.114 0l-2.25-2.5a.75.75 0 1 1 1.114-1.004l.943 1.048V8.75Z" clipRule="evenodd" />
                    </svg>
                    <p>{loading ? "Downloading.." : "Download"}</p>
                </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent className="w-56 mr-4">
                <DropdownMenuItem onClick={handleDownload("csv")} className=" cursor-pointer">CSV</DropdownMenuItem>
                <DropdownMenuItem className=" cursor-pointer">
                    <Link href={`/pdf/${parameter}?pond_id=${pond_id}`} target="_blank" className="w-full text-start">
                        PDF
                    </Link>
                </DropdownMenuItem>
                <DropdownMenuItem onClick={handleDownload("spreadsheet")} className=" cursor-pointer">Spreadsheet</DropdownMenuItem>
                {/* <DropdownMenuItem onClick={handleDownload("spreadsheet")} className=" cursor-pointer">Spreadsheet</DropdownMenuItem> */}
                {/* <DropdownMenuSeparator />
                <DropdownMenuLabel className="text-xs">All Parameters</DropdownMenuLabel>
                <DropdownMenuItem onClick={handleDownload("csv", true)} className=" cursor-pointer">CSV</DropdownMenuItem>
                <DropdownMenuItem onClick={handleDownload("pdf", true)} className=" cursor-pointer">PDF</DropdownMenuItem>
                <DropdownMenuItem onClick={handleDownload("spreadsheet", true)} className=" cursor-pointer">Spreadsheet</DropdownMenuItem> */}
            </DropdownMenuContent>
        </DropdownMenu>
    )
}