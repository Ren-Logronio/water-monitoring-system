"use client";

import { useAuthStore } from "@/store/authStore";
import { useRouter, useSearchParams } from "next/navigation";
import { useEffect, useMemo, useState } from "react";
import { Input } from "../ui/input";
import { Button } from "../ui/button";
import { Label } from "../ui/label";
import { NinetyRing } from "react-svg-spinners"
import { Separator } from "../ui/separator";
import useAuth from "@/hooks/useAuth";

type SignInFormType = {
  email: string;
  password: string;
  loading: boolean;
};

export default function SignInForm() {
  // const { status, message, signIn, signOut, clearStatus } = useAuthStore();
  const { user, signIn, signOut, clearStatus } = useAuth();
  const { status, message } = useMemo(() => user ? user : {status: "idle", message: ""}, [user]);
  const [signInForm, setSignInForm] = useState<SignInFormType>({
    email: "",
    password: "",
    loading: false,
  });
  const router = useRouter();
  const searchParams = useSearchParams();

  const handleInputChange = (e: any) => {
    if (status == "rejected" || status == "error") clearStatus();
    setSignInForm({ ...signInForm, [e.target.name]: e.target.value });
  };

  const handleSignIn = () => {
    setSignInForm({ ...signInForm, loading: true });
    const { email, password } = signInForm;
    signIn(
      email,
      password,
      () => {
        console.log("Success");
        router.replace("/dashboard");
      },
      () => {
        setSignInForm({ email: "", password: "", loading: false });
      },
    );
  };

  useEffect(() => {
    if (searchParams.has("signout")) signOut();
  }, [searchParams]);

  return (
    <div className="flex min-w-full flex-col justify-center md:min-w-[400px]">
      {(status == "rejected" || status == "error") && (
        <p className=" text-center text-red-500">{message}</p>
      )}
      <div className="mt-2">
        <Label className="text-sm text-neutral-600">Email</Label>
        <Input
          disabled={signInForm.loading}
          placeholder="Enter Email"
          className=""
          name="email"
          type="email"
          value={signInForm.email}
          onChange={handleInputChange}
        />
      </div>
      <div className="mt-2">
        <Label className="text-sm text-neutral-600">Password</Label>
        <Input
          disabled={signInForm.loading}
          placeholder="Enter Password"
          name="password"
          type="password"
          value={signInForm.password}
          onChange={handleInputChange}
        />
      </div>
      <Button
        className="mt-[24px] bg-sky-600 text-white"
        disabled={signInForm.loading}
        onClick={handleSignIn}
      >
        { signInForm.loading ? <div className="flex flex-row items-center space-x-2"><NinetyRing color="#ffffff"/><p>Signing In...</p></div> : <>Sign In</> }
      </Button>
      <p className="flex flex-row items-center justify-center space-x-2 mt-[24px] text-center text-[16px] text-neutral-400">
        <span>No Account Yet?</span> 
        <Button onClick={() => router.replace("/signup")} variant="link" className="m-0 p-0 text-sky-600 text-[16px]">Sign up</Button>
      </p>
    </div>
  );
}
