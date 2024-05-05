import SignInForm from "@/components/SignInForm";
import SignUpForm from "@/components/SignUpForm";

export default function Home() {
  return (
    <main className="flex min-h-screen flex-row justify-center bg-neutral-600">
      <div className="flex h-screen w-full flex-col items-center justify-center p-4 lg:w-[50%] md:p-12 bg-white">
        <div className="flex flex-row justify-center items-center mb-4">
          <img src="./logo-orange-cropped.png" className=" mx-auto h-[43.5px] aspect-auto" />
        </div>
        <h2 className=" text-center text-[24px] text-sky-600">Sign Up</h2>
        <SignUpForm />
      </div>
      <div className="h-screen w-0 bg-[url(/bgimg.png)] opacity-75 bg-cover bg-center md:w-[50%]"></div>
    </main>
  );
}
