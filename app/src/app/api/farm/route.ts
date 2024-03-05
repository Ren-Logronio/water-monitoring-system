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
        const [ results, rows ]: [ results: any[], rows: any[] ] = await connection.query(
            "SELECT `farm_id`, `name` FROM `view_farmer_farm` WHERE `user_id` = ?",
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
        const connection = await getMySQLConnection();
        const { name, address_street, address_city, address_province } = await new Response(request.body).json();
        const result = {};
        return NextResponse.json(
            { result },
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