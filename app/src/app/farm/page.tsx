import { Metadata } from "next";
import FarmPage from "@/components/Farm";

export const metadata: Metadata = {
    title: "Farm | Water Monitoring System",
};

export default function Farm() {
    return (
        <FarmPage />
    );
}