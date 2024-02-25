import SignInForm from "@/components/SignInForm";
import Image from "next/image";
import { useState } from "react";


export default function Home() {

  return (
    <main className="min-h-screen flex flex-row justify-center">
        <div className="h-screen flex flex-col justify-center items-center w-full md:w-[50%] p-4 md:p-12">
          <img src="./logo-orange.png" className=" size-28 mx-auto " />
          <h2 className=" font-bold text-center">Sign In</h2>
          <SignInForm />
        </div>
        <div className="h-screen w-0 md:w-[50%] bg-gray-600"></div>
    </main>
  );
}
