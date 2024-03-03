import { verify } from "./Jwt";

export default async function getUserInfo(cookieToken?: string): Promise<{ user_id: string, email: string }>{
    if (!cookieToken) {
        throw new Error("Something went wrong while getting the userId");
    }

    try {
        const res = await verify(cookieToken);
        if (!res) {
            throw new Error("Something went wrong while getting the userId");
        };
        const { user_id, user_email: email } = JSON.parse(res.payload as string);
        return { user_id, email };
    } catch {
        throw new Error("Something went wrong while getting the userId");
    }
}