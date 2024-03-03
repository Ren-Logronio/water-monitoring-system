import Dashboard from "@/components/Dashboard";
import { Metadata } from "next";

export const metadata: Metadata = {
  title: "Dashboard | Water Monitoring System",
};

export default function DashboardPage() {
  return (
    <Dashboard/>
  );
}
