"use client";

import { useAuthStore } from "@/store/authStore";
import { useRouter, useSearchParams } from "next/navigation";
import { useEffect, useState } from "react";
import { Input } from "../ui/input";
import { Button } from "../ui/button";
import { Label } from "../ui/label";
import { NinetyRing } from "react-svg-spinners";
import { Separator } from "../ui/separator";
import passwordValidator from "password-validator";
import axios from "axios";

type SignUpFormType = {
    email: string;
    firstname: string;
    middlename: string;
    lastname: string;
    password: string;
    loading: boolean;
};

export default function SignUpForm() {
  const [signUpForm, setSignUpForm] = useState<SignUpFormType>({
    email: "",
    firstname: "",
    middlename: "",
    lastname: "",
    password: "",
    loading: false,
  });
  const router = useRouter();
  const [message, setMessage] = useState("");

  const handleInputChange = (e: any) => {
    setMessage("");
    setSignUpForm({ ...signUpForm, [e.target.name]: e.target.value });
  };

  const validateEmail = (email: string) => {
    return /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i.test(email);
  };

  const validatePassword = (password: string): any[] => {
    const schema = new passwordValidator();
    schema.is().min(8).has().uppercase().has().lowercase().has().digits().has().symbols().has().not().spaces();
    return schema.validate(password, { list: true }) as any[];
  }

  const handleSignup = () => {
    console.log(validatePassword(signUpForm.password));
    setSignUpForm({ ...signUpForm, loading: true });
    if (signUpForm.email.length <= 0 || signUpForm.firstname.length <= 0 || signUpForm.lastname.length <= 0 || signUpForm.password.length <= 0) {
        setMessage("Please fill out all fields");
        setSignUpForm({ ...signUpForm, loading: false });
        return;
    }
    if (!validateEmail(signUpForm.email)) {
        setMessage("Your email address is invalid");
        setSignUpForm({ ...signUpForm, loading: false });
        return;
    }
    if (validatePassword(signUpForm.password).length) {
        const passwordFlags = validatePassword(signUpForm.password);
        if (passwordFlags.includes("spaces")) {
            setMessage("Your password must not contain spaces");
            setSignUpForm({ ...signUpForm, loading: false });
            return;
        }
        if (passwordFlags.includes("min")) {
            setMessage("Your password must be at least 8 characters");
            setSignUpForm({ ...signUpForm, loading: false });
            return;
        }
        setMessage(`Your password must contain at least one (1) or more ${passwordFlags.filter((item) => !["spaces", "min"].includes(item)).join(", ")}`);
        setSignUpForm({ ...signUpForm, loading: false });
        return;
    }
    axios.post("/api/signup", signUpForm).then(response => {
        console.log(response);
        setSignUpForm({ email: "", firstname: "", middlename: "", lastname: "", password: "", loading: false });
        router.replace("/signin");
    }).catch(error => {
        console.error(error);
        setMessage(error.response.data.message || "An error occurred");
    }).finally(() => {
        setSignUpForm({ ...signUpForm, loading: false });
    });
  }

  return (
    <div className="flex min-w-full flex-col justify-center md:min-w-[400px] max-w-[400px]">
        {(message) && (
            <p className=" text-center text-red-500">{message}</p>
        )}
        <div className="mt-2">
            <Label className="text-sm text-neutral-600">Email</Label>
            <Input
            disabled={signUpForm.loading}
            placeholder="Enter Email"
            className=""
            name="email"
            type="email"
            value={signUpForm.email}
            onChange={handleInputChange}
            />
        </div>
        <div className="mt-2">
            <Label className="text-sm text-neutral-600">First Name</Label>
            <Input
            disabled={signUpForm.loading}
            placeholder="Enter First Name"
            name="firstname"
            value={signUpForm.firstname}
            onChange={handleInputChange}
            />
        </div>
        <div className="mt-2">
            <Label className="text-sm text-neutral-600">Middle Name</Label>
            <Input
            disabled={signUpForm.loading}
            placeholder="Enter Middle Name"
            name="middlename"
            value={signUpForm.middlename}
            onChange={handleInputChange}
            />
        </div>
        <div className="mt-2">
            <Label className="text-sm text-neutral-600">Last Name</Label>
            <Input
            disabled={signUpForm.loading}
            placeholder="Enter Last Name"
            name="lastname"
            value={signUpForm.lastname}
            onChange={handleInputChange}
            />
        </div>
        <div className="mt-2">
            <Label className="text-sm text-neutral-600">Password</Label>
            <Input
            disabled={signUpForm.loading}
            placeholder="Enter Password"
            name="password"
            type="password"
            value={signUpForm.password}
            onChange={handleInputChange}
            />
        </div>
        <Button
            className="mt-[24px] bg-sky-600 text-white"
            disabled={signUpForm.loading}
            onClick={handleSignup}
        >
            { signUpForm.loading ? <div className="flex flex-row items-center space-x-2"><NinetyRing color="#ffffff"/><p>Signing Up...</p></div> : <>Sign Up</> }
        </Button>
        <p className="flex flex-row items-center justify-center space-x-2 mt-[24px] text-center text-[16px] text-neutral-400"><span>Already have an account?</span> <Button onClick={() => router.replace("/signin")} variant="link" className="m-0 p-0 text-sky-600 text-[16px]">Sign In</Button></p>
    </div>
  );
}
