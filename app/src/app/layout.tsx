import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";
import { ThemeProvider } from "@/components/ThemeProvider";
import NavigationBar from "@/components/NavigationBar";
import { Suspense } from "react";
import Loading from "@/components/Loading";
import FarmProvider from "@/providers/FarmProvider";
import AuthProvider from "@/providers/AuthProvider";
import ModalProvider from "@/providers/ModalProvider";
import { Toaster } from "@/components/ui/toaster";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "Capstone",
  description: "No Description",
};

export default function RootLayout({
  children,
}: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="en">
      <body className={`${inter.className} bg-[#FAFAFA]`}>
        <ThemeProvider
          attribute="class"
          defaultTheme="system"
          enableSystem
          disableTransitionOnChange
        >
          <AuthProvider>
            <FarmProvider>
              <ModalProvider>
                <NavigationBar>
                  <Suspense fallback={<Loading />}>
                    {children}
                  </Suspense>
                  <Toaster />
                </NavigationBar>
              </ModalProvider>
            </FarmProvider>
          </AuthProvider>
        </ThemeProvider>
      </body>
    </html>
  );
}
