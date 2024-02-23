import SignInForm from "@/components/SignInForm";
import Image from "next/image";
import { useState } from "react";


export default function Home() {

  return (
    <main className="flex min-h-screen flex-col items-center justify-between p-24">
      <div className="border border-black">
        <SignInForm />
      </div>
    </main>
  );
}
