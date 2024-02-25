"use client";

import { useAuthStore } from "@/store/authStore";
import { useRouter } from "next/navigation";
import { useState, useEffect } from "react";
import { Input } from "../ui/input";
import { Button } from "../ui/button";
import { Label } from "../ui/label";

type SignInFormType = {
    email: string;
    password: string;
    loading: boolean;
};

export default function SignInForm() { 
    const router = useRouter();
    const { status, message, signIn, clearStatus } = useAuthStore();
    const [ signInForm, setSignInForm ] = useState<SignInFormType>({ email: '', password: '', loading: false});
  
    const handleInputChange = (e: any) => setSignInForm({ ...signInForm, [e.target.name]: e.target.value });

    const handleSignIn = () => {
        setSignInForm({ ...signInForm, loading: true });
        const { email, password } = signInForm;
        signIn(email, password, () => { 
            router.push('/dashboard');
            setSignInForm({ email: '', password: '', loading: false });
        }, () => { 
            setSignInForm({ email: '', password: '', loading: false }) 
        });
    };

    return (
        <div className="flex flex-col justify-center min-w-full md:min-w-[400px]">
            { (status == 'rejected' || status == 'error') && <p className=" text-red-500 text-center">{ message }</p> }
            <div className="mt-2">
                <Label>Email</Label>
                <Input disabled={signInForm.loading} placeholder="Enter Email" className="" name="email" type="email" value={signInForm.email} onChange={handleInputChange} />
            </div>
            <div className="mt-2">
                <Label>Password</Label>
                <Input disabled={signInForm.loading} placeholder="Enter Password" name="password" type="password" value={signInForm.password} onChange={handleInputChange} />
            </div>
            <Button className="mt-4" disabled={signInForm.loading} onClick={handleSignIn}>Sign In</Button>
        </div>
    )
}