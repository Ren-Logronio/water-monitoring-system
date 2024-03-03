import { SignJWT, jwtVerify, type JWTPayload } from 'jose';

export async function sign(payload: string): Promise<string> {
    const secret = process.env.APP_PRIVATE_KEY || "mykey"; //! REMOVE 'mykey' WHEN DEPLOYING TO PRODUCTION
    const iat = Math.floor(Date.now() / 1000);
    const exp = iat + 60 * 60 * 24; // one hour
    

    return new SignJWT({ payload })
        .setProtectedHeader({ alg: 'HS256', typ: 'JWT' })
        .setExpirationTime(exp)
        .setIssuedAt(iat)
        .setNotBefore(iat)
        .sign(new TextEncoder().encode(secret));
}

export async function verify(token: any): Promise<JWTPayload | false> {
    try {
        const secret = process.env.APP_PRIVATE_KEY || "mykey"; //! REMOVE 'mykey' WHEN DEPLOYING TO PRODUCTION
        const { payload } = await jwtVerify(token, new TextEncoder().encode(secret));
        return payload;
    } catch (error) {
        return false;
    }
}