import bcrypt from "bcrypt";
import { NextApiRequest } from "next";
import { NextResponse } from "next/server";

const mockEmail = "test@gmail.com";
const mockPassword = "$2a$12$DwFjWCsUgXDZDsNBa.ws5eEpPbZvYpnhry.zSQTuHHIv5vUcIM.Oi";

export async function POST(request: NextApiRequest) { 
    const { email, password } = await new Response(request.body).json();
    const passwordComparison = bcrypt.compareSync(password, mockPassword);
    if (email === mockEmail && passwordComparison) {
        return NextResponse.json({ success: true, token: "1234", message: "Successfully signed in" });
    } else {
        return NextResponse.json({ success: false, message: "Invalid email or password" }, {
            // bad request
            status: 400
        });
    }
}