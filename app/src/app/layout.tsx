import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";
import ProtectedRoute from "@/components/ProtectedRoute";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "Water Monitoring System",
  description: "No Description",
};

export default function RootLayout({children}: Readonly<{ children: React.ReactNode; }>) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <ProtectedRoute>
          {children}
        </ProtectedRoute>
      </body>
    </html>
  );
}
