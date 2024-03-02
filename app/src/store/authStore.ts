import { create } from "zustand";
import axios from "axios";
import Cookies from "js-cookie";

type AuthStore = {
  email?: string;
  firstname?: string;
  lastname?: string;
  middlename?: string;
  status: "idle" | "pending" | "resolved" | "rejected" | "error";
  message?: string;
  clearStatus: () => void;
  signOut: () => void;
  signIn: (
    email: string,
    password: string,
    successCallback: () => void,
    failureCallback: () => void,
  ) => void;
  // setToken: (token: string) => void;
};

export const useAuthStore = create<AuthStore>((set) => ({
  status: "idle", // 'idle' | 'pending' | 'resolved' | 'rejected
  firstname: "",
  lastname: "",
  message: "",
  clearStatus: () => set({ status: "idle", message: "" }),
  signOut: () => {
    Cookies.remove("token");
    set({ status: "idle", firstname: "", lastname: "" });
  },
  signIn: async (email, password, successCallback, failureCallback) => {
    // call the api
    axios
      .post("/api/signin", { email, password })
      .then((response) => {
        const { token, firstname, lastname } = response.data;
        // set the token in the cookie
        Cookies.set("token", token, { expires: 2, sameSite: "strict" });
        set({ status: "resolved", firstname, lastname });
        // invoke the callback function containing route.push()
        successCallback();
      })
      .catch((error) => {
        set({ status: "rejected", message: error.response.data.message });
        failureCallback();
      });
  },
}));
