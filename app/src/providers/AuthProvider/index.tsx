"use client";

import { createContext, useEffect, useState } from "react";
import Cookies from "js-cookie";
import axios from "axios";
import { set } from "date-fns";

// import { create } from "zustand";
// import axios from "axios";


// type AuthStore = {
//   email?: string;
//   firstname?: string;
//   lastname?: string;
//   middlename?: string;
//   status: "idle" | "pending" | "resolved" | "rejected" | "error";
//   message?: string;
//   clearStatus: () => void;
//   signOut: () => void;
//   signIn: (
//     email: string,
//     password: string,
//     successCallback: () => void,
//     failureCallback: () => void,
//   ) => void;
//   // setToken: (token: string) => void;
// };

// export const useAuthStore = create<AuthStore>((set) => ({
//   status: "idle", // 'idle' | 'pending' | 'resolved' | 'rejected'
//   message: "",
//   clearStatus: () => set({ status: "idle", message: "" }),
//   signOut: () => {
//     Cookies.remove("token");
//     set({ status: "idle" });
//   },
//   signIn: async (email, password, successCallback, failureCallback) => {
//     // call the api
//     axios
//       .post("/api/signin", { email, password })
//       .then((response) => {
//         const { token, firstname, lastname } = response.data;
//         // set the token in the cookie
//         Cookies.set("token", token, { expires: 2, sameSite: "strict" });
//         localStorage.setItem("firstname", firstname);
//         localStorage.setItem("lastname", lastname);
//         set({ status: "resolved", firstname, lastname });
//         // invoke the callback function containing route.push()
//         successCallback();
//       })
//       .catch((error) => {
//         set({ status: "rejected", message: error.response.data.message });
//         failureCallback();
//       });
//   },
// }));

export type UserType = {
    email?: string;
    firstname?: string;
    lastname?: string;
    middlename?: string;
    status?: "idle" | "pending" | "resolved" | "rejected" | "error";
    message?: string;
}

export type UserEventType = "signin" | "signout";

export type AuthContextType = {
    user: UserType | null;
    clearStatus: () => void;
    signOut: () => void;
    signIn: (
        email: string, 
        password: string, 
        successCallback: () => void, 
        failureCallback: () => void
    ) => Promise<void>;
    addEventListener: (event: UserEventType, eventCallback: () => void) => number;
    removeEventListener: (id: number) => void;
};

export const AuthContext = createContext<AuthContextType>({
    user: null,
    clearStatus: async () => { return; },
    signIn: async () => {},
    signOut: async () => {},
    addEventListener: () => 0,
    removeEventListener: () => {}
});

export default function AuthProvider({ children }: { children: React.ReactNode }) {
    const [user, setUser] = useState<UserType | null>(null);
    const [listeners, setListener] = useState<({id: number, callback: (event: UserEventType) => void})[]>([]);
    const [listenerIndex, setListenerIndex] = useState<number>(0);

    useEffect(() => {
        setUser({
            email: localStorage.getItem("email") || undefined,
            firstname: localStorage.getItem("firstname") || undefined,
            middlename: localStorage.getItem("middlename") || undefined,
            lastname: localStorage.getItem("lastname") || undefined,
            status: "idle",
            message: ""
        });
    }, []);

    const clearStatus = () => {
        setUser(user ? { ...user, status: "idle", message: "" } : { status: "idle", message: ""});
    };

    const signOut = () => {
        Cookies.remove("token");
        setUser({ status: "idle", message: "" });
        localStorage.removeItem("firstname");
        localStorage.removeItem("lastname");
        listeners.forEach((listener) => listener.callback("signout"));
    };

    const signIn = async (
        email: string, 
        password: string, 
        successCallback: () => void, 
        failureCallback: () => void
    ) => {
        axios
        .post("/api/signin", { email, password })
        .then((response) => {
            const { token, firstname, middlename, lastname, email } = response.data;
            Cookies.set("token", token, { expires: 2, sameSite: "strict" });
            localStorage.setItem("firstname", firstname);
            localStorage.setItem("middlename", middlename);
            localStorage.setItem("lastname", lastname);
            localStorage.setItem("email", email);
            setUser(user ? { ...user, status: "resolved", firstname, lastname, email } : { status: "resolved", firstname, lastname });
            listeners.forEach((listener) => listener.callback("signin"));
            successCallback();
        })
        .catch((error) => {
            setUser(user ? { ...user, status: "rejected", message: error.response.data.message } : { status: "rejected", message: error.response.data.message });
            failureCallback();
        });
    };

    const addEventListener = (
        event: UserEventType, 
        eventCallback: () => void
    ) => {
        const mutatedCallback = (currentEvent: UserEventType) => {
            if (currentEvent === event) {
                console.log("EVENT CALLBACK:", currentEvent, "<>", event);
                eventCallback()
            };
        }
        setListener(prevListeners => [...prevListeners, {id: listenerIndex, callback: mutatedCallback}]);
        setListenerIndex(listenerIndex + 1);
        return listenerIndex;
    };

    const removeEventListener = (id: number) => {
        setListener(listeners.filter((listener) => listener.id !== id));
    };

    useEffect(() => {
        console.log("EVENT LISTENERS:", listeners);
    }, [listeners])

    return <AuthContext.Provider value={{user, clearStatus, signIn, signOut, addEventListener, removeEventListener}}>
        {children}
    </AuthContext.Provider>;
}