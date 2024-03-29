import getMySQLConnection from "@/db/mysql";
import getUserInfo from "@/utils/User";
import { NextApiRequest } from "next";
import { cookies } from "next/headers";
import { NextRequest, NextResponse } from "next/server";

export async function GET(req: NextApiRequest) {
  try {
    const cookieToken = cookies().get('token')?.value;
    const connection = await getMySQLConnection();
    const { user_id } = await getUserInfo(cookieToken);
    const [results, rows]: [results: any[], rows: any[]] = await connection.query(
      "SELECT * FROM `view_farmer_ponds` WHERE `user_id` = ?",
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

export async function POST(req: NextApiRequest) {
  try {
    const connection = await getMySQLConnection();
    const { farm_id, name, width, length, depth, method } = await new Response(req.body).json();
    const pondInsertResult = await connection.query(
      "INSERT INTO `ponds` (`device_id`, `farm_id`, `name`, `width`, `length`, `depth`, `method`) VALUES (?, ?, ?, ?, ?, ?, ?)",
      [null, farm_id, name, width, length, depth, method]
    );
    return NextResponse.json(
      { message: "Pond inserted successfully" },
      {
        status: 200,
      },
    );
  } catch (error) {
    console.log(error);
    return NextResponse.json(
      { message: "Something went wrong while updating the pond" },
      {
        status: 500,
      },
    );
  }
}

export async function DELETE(request: NextRequest) {
  try {
    const pond_id = request.nextUrl.searchParams.get('pond_id');
    const connection = await getMySQLConnection();
    const pondDeleteResult = await connection.query(
      "DELETE FROM `ponds` WHERE `pond_id` = ?",
      [pond_id]
    );
    return NextResponse.json(
      { message: "Pond deleted successfully" },
      {
        status: 200,
      },
    );
  } catch (error) {
    console.log(error);
    return NextResponse.json(
      { message: "Something went wrong while deleting the pond" },
      {
        status: 500,
      },
    );
  }
}