import getMySQLConnection from "@/db/mysql";
import { NextRequest, NextResponse } from "next/server";
import bcrypt from "bcrypt";

export async function POST(request: NextRequest) {
    try {
        const connection = await getMySQLConnection();
        const { email, firstname, middlename, lastname, password } = await request.json();
        const hashedPassword = await bcrypt.hash(password, 10);
        const [users]: any = await connection.query("SELECT * FROM users WHERE email = ?", [email]);
        if (users.length) {
            return NextResponse.json({ message: "User with your email already exists" }, { status: 400 });
        }
        const [resultHeader] = await connection.query(
            "INSERT INTO users (email, firstname, middlename, lastname, password) VALUES (?, ?, ?, ?, ?)", 
            [email, firstname, middlename, lastname, hashedPassword]
        );
        console.log(resultHeader);
        return NextResponse.json({ message: "User created" }, { status: 201 });
    } catch (error: any) {
        console.error(error);
        return NextResponse.json({ message: error.message || "An error occurred" }, { status: 500 });
    }
}