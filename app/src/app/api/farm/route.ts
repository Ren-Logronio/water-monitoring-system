import getMySQLConnection from "@/db/mysql";
import { verify } from "@/utils/Jwt";
import getUserInfo from "@/utils/User";
import { NextApiRequest } from "next";
import { cookies } from "next/headers";
import { NextRequest, NextResponse } from "next/server";

export async function GET(request: NextApiRequest) {
    try {
        const cookieToken = cookies().get('token')?.value;
        const connection = await getMySQLConnection();
        const { user_id } = await getUserInfo(cookieToken);
        const [results, rows]: [results: any[], rows: any[]] = await connection.query(
            "SELECT * FROM `view_farmer_farm` WHERE `user_id` = ?",
            [user_id]
        );
        return NextResponse.json(
            { results },
            {
                status: 200,
            },
        );
    } catch (err: any) {
        console.log(err)
        return NextResponse.json(
            { message: "Something went wrong while getting the farm info" },
            {
                status: 500,
            },
        );
    }
}

export async function POST(request: NextApiRequest) {
    try {
        const cookieToken = cookies().get('token')?.value;
        const connection = await getMySQLConnection();
        const { user_id } = await getUserInfo(cookieToken);
        const { name, address_street, address_city, address_province } = await new Response(request.body).json();
        const [results, rows]: [results: any, rows: any[]] = await connection.query(
            "INSERT INTO `farms` (`name`, `address_street`, `address_city`, `address_province`) VALUES (?, ?, ?, ?)",
            [name, address_street, address_city, address_province]
        );
        const lastInsertedId = results.insertId;
        const [results2, rows2]: [results: any, rows: any[]] = await connection.query(
            "INSERT INTO `farm_farmer` (`farmer_id`, `farm_id`, `role`, `is_approved`) VALUES (?, ?, ?, 1)",
            [user_id, lastInsertedId, "OWNER"]
        );
        return NextResponse.json(
            { results: results2 },
            {
                status: 200,
            },
        );
    } catch (err: any) {
        console.log(err)
        return NextResponse.json(
            { message: "Something went wrong while adding the farm" },
            {
                status: 500,
            },
        );
    }
}