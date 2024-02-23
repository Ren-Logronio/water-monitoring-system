"use client";

import { useAuthStore } from "@/store/authStore";
import { useRouter } from "next/navigation";
import { useState, useEffect } from "react";

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
        const { email, password } = signInForm;
        signIn(email, password, () => { 
            router.push('/dashboard');
        });

    };

    useEffect(() => {
        
    }, []);

    return (
        <div className="flex flex-col items-center justify-center">
            { (status == 'rejected' || status == 'error') && <p className=" text-red-500">{ message }</p> }
            <p>Sign In</p>
            <input name="email" type="email" value={signInForm.email} onChange={handleInputChange} />
            <input name="password" type="password" value={signInForm.password} onChange={handleInputChange} />
            <button disabled={signInForm.loading} onClick={handleSignIn}>Sign In</button>
        </div>
    )
}