import Image from "next/image";
import { NinetyRing } from "react-svg-spinners";


export default function Loading() {
  return (
    <div className="flex flex-col justify-center items-center w-full h-screen space-y-4">
        <Image src={"/logo-orange-cropped.png"} height={32} width={87} className="aspect-auto" alt="loading..."></Image>
        <NinetyRing color="#000000"/>
    </div>
  );
}