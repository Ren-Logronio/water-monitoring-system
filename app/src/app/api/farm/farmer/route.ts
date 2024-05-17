import getMySQLConnection from "@/db/mysql";
import getUserInfo from "@/utils/User";
import { format } from "date-fns";
import { NextApiRequest } from "next";
import { cookies } from "next/headers";
import { NextRequest, NextResponse } from "next/server";

export async function GET(request: NextRequest) {
    try {
        const cookieToken = cookies().get('token')?.value;
        const { user_id } = await getUserInfo(cookieToken);
        const farm_id = request.nextUrl.searchParams.get("farm_id");
        const connection = await getMySQLConnection();
        const [results, rows]: [results: any, rows: any[]] = await connection.query(
            "SELECT * FROM `view_farm_farmers` WHERE `farm_id` = ?",
            [farm_id]
        );
        const filterPassword = results.map((i: any) => {
            const { password, ...rest } = i;
            return rest;
        });
        const withMeDetermined = filterPassword.map((i: any) => { return i.farmer_id === user_id ? { ...i, me: true } : i });
        return NextResponse.json(
            { results: withMeDetermined },
            {
                status: 200,
            },
        );
    } catch (err: any) {
        console.log(err)
        return NextResponse.json(
            { message: "Something went wrong while fetching farm details" },
            {
                status: 500,
            },
        );
    }
}

export async function PATCH(request: NextRequest) {
    try {
        const connection = await getMySQLConnection();
        const farmer_id = request.nextUrl.searchParams.get("farmer_id");
        await connection.query(
            "UPDATE `farm_farmer` SET `is_approved` = TRUE WHERE `farmer_id` = ?",
            [farmer_id]
        );
        await connection.query(
            "INSERT INTO `user_notifications` (`user_id`, `action`, `message`) VALUES (?, ?, ?)",
            [farmer_id, "INFO", `Your request to join the farm has been approved.`]
        );
        return NextResponse.json(
            { message: "Staff approved" },
            {
                status: 200,
            },
        );
    } catch (err: any) {
        console.log(err)
        return NextResponse.json(
            { message: "Something went wrong while updating staff approval" },
            {
                status: 500,
            },
        );
    }
}

export async function POST(request: NextRequest) {
    try {
        const cookieToken = cookies().get('token')?.value;
        const connection = await getMySQLConnection();
        const { user_id } = await getUserInfo(cookieToken);
        const { farm, isOwner } = await request.json();
        const role = isOwner ? "OWNER" : "STAFF";
        const [results, rows]: [results: any, rows: any[]] = await connection.query(
            "INSERT INTO `farm_farmer` (`farmer_id`, `farm_id`, `role`) VALUES (?, ?, ?)",
            [user_id, farm.farm_id, role]
        );
        await connection.query(
            "INSERT INTO `user_notifications` (`user_id`, `action`, `message`) VALUES (?, ?, ?)",
            [user_id, "INFO", `You have been added as a ${role} to ${farm.name}, please wait for the farm owner's verification..`]
        );
        const [farms]: any = await connection.query(
            "SELECT * FROM `view_farmer_farm` WHERE `user_id` = ? AND `farm_id` = ?",
            [user_id, farm.farm_id]
        );
        return NextResponse.json(
            { results, result: farms[0] },
            {
                status: 200,
            },
        );
    } catch (err: any) {
        console.log(err)
        return NextResponse.json(
            { message: "Something went wrong while entering farm details" },
            {
                status: 500,
            },
        );
    }
}

export async function DELETE(request: NextRequest) {
    try {
        const connection = await getMySQLConnection();
        const pond_id = request.nextUrl.searchParams.get("farmer_id");
        await connection.query(
            "DELETE FROM `farm_farmer` WHERE `farmer_id` = ?",
            [pond_id]
        );
        await connection.query(
            "INSERT INTO `user_notifications` (`user_id`, `action`, `message`) VALUES (?, ?, ?)",
            [pond_id, "INFO", `You have been removed from the farm.`]
        );
        return NextResponse.json(
            { message: "Pond deleted" },
            {
                status: 200,
            },
        );
    } catch (err: any) {
        console.log(err)
        return NextResponse.json(
            { message: "Something went wrong while deleting pond" },
            {
                status: 500,
            },
        );
    }
}