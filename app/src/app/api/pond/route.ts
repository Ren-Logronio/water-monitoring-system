import getMySQLConnection from "@/db/mysql";
import getUserInfo from "@/utils/User";
import { NextApiRequest } from "next";
import { cookies } from "next/headers";
import { NextResponse } from "next/server";

export async function GET(req: NextApiRequest) {
  try {
    const cookieToken = cookies().get('token')?.value;
    const connection = await getMySQLConnection();
    const { user_id } = await getUserInfo(cookieToken);
    const [ results, rows ]: [ results: any[], rows: any[] ] = await connection.query(
        "SELECT `device_id`, `name` FROM `view_farmer_ponds` WHERE `user_id` = ?",
        [user_id]
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
        { message: "Something went wrong while getting the farm info" },
        {
            status: 500,
        },
    );
  }
}