import { FarmContext } from "@/providers/FarmProvider";
import { useContext } from "react";

export default function useFarm() {
    return useContext(FarmContext);
}