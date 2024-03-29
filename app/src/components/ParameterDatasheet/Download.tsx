import { useParams } from "next/navigation";
import { Button } from "../ui/button";
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger } from "../ui/dropdown-menu";
import { useState } from "react";
import { useParameterDatasheetStore } from "@/store/parameterDatasheetStore";
import axios from "axios";


export default function Download({ pond_id }: { pond_id?: string }) {
    const [loading, setLoading] = useState(false);
    const { rowData } = useParameterDatasheetStore();
    const { parameter } = useParams();

    const handleDownload = (format: string) => {
        return () => {
            setLoading(true);
            axios.get(`/api/download?format=${format}&pond_id=${pond_id}&parameter=${parameter}`).then(res => {
                console.log(res);
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
            <DropdownMenuContent className="w-56">
                <DropdownMenuItem onClick={handleDownload("csv")} className=" cursor-pointer">CSV</DropdownMenuItem>
                <DropdownMenuItem onClick={handleDownload("pdf")} className=" cursor-pointer">PDF</DropdownMenuItem>
                <DropdownMenuItem onClick={handleDownload("spreadsheet")} className=" cursor-pointer">Spreadsheet</DropdownMenuItem>
            </DropdownMenuContent>
        </DropdownMenu>
    )
}