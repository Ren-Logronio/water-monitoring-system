"use client";

import { useAuthStore } from "@/store/authStore";
import { useRouter, useSearchParams } from "next/navigation";
import { useState } from "react";
import { Input } from "../ui/input";
import { Button } from "../ui/button";
import { Label } from "../ui/label";
import Cookies from "js-cookie";
import { cookies } from "next/headers";

type SignInFormType = {
  email: string;
  password: string;
  loading: boolean;
};

export default function SignInForm() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const { status, message, signIn, clearStatus } = useAuthStore();
  const [signInForm, setSignInForm] = useState<SignInFormType>({
    email: "",
    password: "",
    loading: false,
  });
  
  if (searchParams.has("signout")) Cookies.remove("token");

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
        router.push("/dashboard");
      },
      () => {
        setSignInForm({ email: "", password: "", loading: false });
      },
    );
  };

  return (
    <div className="flex min-w-full flex-col justify-center md:min-w-[400px]">
      {(status == "rejected" || status == "error") && (
        <p className=" text-center text-red-500">{message}</p>
      )}
      <div className="mt-2">
        <Label>Email</Label>
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
        <Label>Password</Label>
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
        className="mt-4"
        disabled={signInForm.loading}
        onClick={handleSignIn}
      >
        Sign In
      </Button>
    </div>
  );
}
