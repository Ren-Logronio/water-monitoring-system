import { createContext, useContext, useState } from "react";

export const AuthContext = createContext({});

export const useAuth = () => useContext(AuthContext);

export default function AuthProvider({ children }: { children: string | JSX.Element | JSX.Element[] | React.JSX.Element }) {
    const [auth, setAuth] = useState(!!localStorage.getItem('token'));

    const justDoNothingYet = () => {
        return;
    };

    return (
        <AuthContext.Provider value={{auth, justDoNothingYet}}>
            { children }
        </AuthContext.Provider>
    );
}