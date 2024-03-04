import getMySQLConnection from "@/db/mysql";
import getUserInfo from "@/utils/User";
import { NextApiRequest } from "next";
import { cookies } from "next/headers";
import { NextRequest, NextResponse } from "next/server";

export async function GET(request: NextRequest ) {
  try {
    const device_id = request.nextUrl.searchParams.get('device_id');
    const connection = await getMySQLConnection();
    const [ results, rows ]: [ results: any[], rows: any[] ] = await connection.query(
        "SELECT * FROM `view_pond_sensors` WHERE `device_id` = ?",
        [device_id]
    );
    return NextResponse.json(
        { results },
        {
            status: 200,
        },
    );
  } catch (error) {
    console.log(error);
    return NextResponse.json(
        { message: "Something went wrong while getting the sensor info" },
        {
            status: 500,
        },
    );
  }
}