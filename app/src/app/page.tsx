import SignInForm from "@/components/SignInForm";
import Image from "next/image";
import { useState } from "react";

export default function Home() {
  return (
    <main className="flex min-h-screen flex-row justify-center">
      <div className="flex h-screen w-full flex-col items-center justify-center p-4 md:w-[50%] md:p-12">
        <img src="./logo-orange.png" className=" mx-auto size-28 " />
        <h2 className=" text-center font-bold">Sign In</h2>
        <SignInForm />
      </div>
      <div className="h-screen w-0 bg-gray-600 md:w-[50%]"></div>
    </main>
  );
}
