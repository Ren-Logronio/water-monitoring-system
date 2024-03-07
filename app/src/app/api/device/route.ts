import getMySQLConnection from "@/db/mysql";
import { NextApiRequest } from "next";
import { NextRequest, NextResponse } from "next/server";

export async function GET(request: NextRequest) {
    try {
        const device_id = request.nextUrl.searchParams.get('device_id');
        const connection = await getMySQLConnection();
        const [results, rows]: [results: any[], rows: any[]] = await connection.query(
            "SELECT * FROM `device` WHERE `device_id` = ? AND `status` = 'IDLE'",
            [device_id]
        );
        console.log(results);
        return NextResponse.json(
            { results },
            {
                status: 200,
            },
        );
    } catch (e: any) {
        return NextResponse.json(
            { message: "Something went wrong while getting device" },
            {
                status: 500,
            },
        );
    }
}

export async function PATCH(request: NextRequest) {
    try {
        const connection = await getMySQLConnection();
        const { device_id, status } = await new Response(request.body).json();
        await connection.query(
            "UPDATE `device` SET `status` = ? WHERE `device_id` = ?",
            [status, device_id]
        );
        return NextResponse.json(
            { message: "Device status updated successfully" },
            {
                status: 200,
            },
        );
    } catch (e: any) {
        return NextResponse.json(
            { message: "Something went wrong while updating the device status" },
            {
                status: 500,
            },
        );
    }
}