import { create } from 'zustand';
import axios from 'axios';
import Cookies from 'js-cookie';

type AuthStore = {
    email?: string;
    firstname?: string;
    lastname?: string;
    middlename?: string;
    status: 'idle' | 'pending' | 'resolved' | 'rejected' | 'error';
    message?: string;
    clearStatus: () => void;
    signIn: (email: string, password: string, successCallback: () => void, failCallback: () => void) => void;
    // setToken: (token: string) => void;
};

export const useAuthStore = create<AuthStore>((set) => ({
    status: 'idle', // 'idle' | 'pending' | 'resolved' | 'rejected
    message: '',
    clearStatus: () => set({ status: 'idle', message: '' }),
    signIn: async (email, password, successCallback, failCallback) => {
        // call the api
        axios.post('/api/signin', { email, password }).then((response) => {
            const { token } = response.data;
            // set the token in the cookie
            Cookies.set('token', token);
            // invoke the callback function containing route.push()
            successCallback();
        }).catch((error) => {
            set({ status: 'rejected', message: error.response.data.message });
            failCallback();
        });
    },
}));

