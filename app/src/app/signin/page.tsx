import SignInForm from "@/components/SignInForm";

export default function Home() {
  return (
    <main className="flex min-h-screen flex-row justify-center">
      <div className="flex h-screen w-full flex-col items-center justify-center p-4 md:w-[50%] md:p-12 bg-white">
        <div className="flex flex-row justify-center items-center mb-4">
          <img src="./logo-orange.png" className=" mx-auto size-28" />
          <div className="flex flex-col text-[26px] font-semibold text-[#FF9B42]">
            <p>Water</p>
            <p>Monitoring</p>
            <p>System</p>
          </div>
        </div>
        <h2 className=" text-center font-bold">Sign In</h2>
        <SignInForm />
      </div>
      <div className="h-screen w-0 bg-gray-600 md:w-[50%]"></div>
    </main>
  );
}
