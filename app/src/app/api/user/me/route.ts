import getMySQLConnection from "@/db/mysql";
import getUserInfo from "@/utils/User";
import { cookies } from "next/headers";
import { NextRequest, NextResponse } from "next/server";

export async function GET(req: NextRequest) {
  try {
    const cookieToken = cookies().get('token')?.value;
    const connection = await getMySQLConnection();
    const { user_id } = await getUserInfo(cookieToken);
    const [results, rows]: [results: any[], rows: any[]] = await connection.query(
      "SELECT * FROM `users` WHERE `user_id` = ?",
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
      { message: "Something went wrong while getting the pond info" },
      {
        status: 500,
      },
    );
  }
}