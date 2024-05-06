import getMySQLConnection from "@/db/mysql";
import getUserInfo from "@/utils/User";
import { ResultSetHeader } from "mysql2";
import { NextApiRequest } from "next";
import { cookies } from "next/headers";
import { NextRequest, NextResponse } from "next/server";

export async function GET(req: NextRequest) {
  try {
    const cookieToken = cookies().get('token')?.value;
    const connection = await getMySQLConnection();
    const { user_id } = await getUserInfo(cookieToken);
    const farm_id = req.nextUrl.searchParams.has("farm_id") ? req.nextUrl.searchParams.get("farm_id") : null;
    const [results, rows]: [results: any[], rows: any[]] = farm_id ?
      await connection.query(
        "SELECT * FROM `view_farmer_ponds` WHERE `user_id` = ? AND `farm_id` = ?",
        [user_id, farm_id]
      )
      :
      await connection.query(
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

export async function POST(req: NextRequest) {
  try {
    const connection = await getMySQLConnection();
    const {device_id, farm_id, name, width, length, depth, method } = await req.json();
    await connection.query(
      "INSERT INTO `ponds` (`device_id`, `farm_id`, `name`, `width`, `length`, `depth`, `method`) VALUES (?, ?, ?, ?, ?, ?, ?)",
      [(device_id || null), farm_id, name, width, length, depth, method]
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

export async function PATCH(request: NextRequest) {
  try {
    const {pond_id, device_id, name, width, length, depth, method } = await request.json();
    const connection = await getMySQLConnection();
    const pondUpdateResult = await connection.query(
      "UPDATE `ponds` SET `device_id` = ?, `name` = ?, `width` = ?, `length` = ?, `depth` = ?, `method` = ? WHERE `pond_id` = ?",
      [device_id, name, width, length, depth, method, pond_id]
    );
    return NextResponse.json(
      { message: "Pond updated successfully" },
      {
        status: 200,
      },
    );
  } catch (error: any) {
    console.log(error);
    return NextResponse.json(
      { message: error.message || "Something went wrong while deleting the pond" },
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
    const [ponds]: any = await connection.query("SELECT * FROM `ponds` WHERE `pond_id` = ?", [pond_id]);
    if (ponds.length === 0) {
      return NextResponse.json(
        { message: "Pond not found" },
        {
          status: 404,
        },
      );
    };
    if (ponds[0].device_id) {
      await connection.query("UPDATE `devices` SET `status` = 'IDLE' WHERE `device_id` = ?", [ponds[0].device_id]);
    };
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