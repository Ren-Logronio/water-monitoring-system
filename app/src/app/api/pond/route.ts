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
    const [results, rows]: [results: any[], rows: any[]] = await connection.query(
      "SELECT `device_id`, `name`, `status` FROM `view_farmer_ponds` WHERE `user_id` = ?",
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
    const { name, status } = await new Response(req.body).json();
    const result = {};
    return NextResponse.json(
      { result },
      {
        status: 200,
      },
    );
  } catch (error) {
    console.log(error);
    return NextResponse.json(
      { message: "Something went wrong while adding the pond" },
      {
        status: 500,
      },
    );
  }
}

export async function PATCH(req: NextApiRequest) {
  try {
    const connection = await getMySQLConnection();
    const { device_id, farm_id, name, width, length, depth, method } = await new Response(req.body).json();
    await connection.query(
      "UPDATE `ponds` SET `status` = 'ACTIVE', `farm_id` = ?, `name` = ?, `width` = ?, `length` = ?, `depth` = ?, `method` = ? WHERE `device_id` = ?",
      [farm_id, name, width, length, depth, method, device_id]
    );
    return NextResponse.json(
      { message: "Pond updated successfully" },
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