import getMySQLConnection from "@/db/mysql";
import { NextApiRequest } from "next";
import { NextRequest, NextResponse } from "next/server";

export async function GET(request: NextRequest) {
  try {
    const parameter_id = request.nextUrl.searchParams.get('parameter_id');
    const connection = await getMySQLConnection();
    const [results, rows]: [results: any[], rows: any[]] = await connection.query(
      "SELECT * FROM `readings` WHERE `parameter_id` = ?",
      [parameter_id]
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
      { message: "Something went wrong while getting the readings info" },
      {
        status: 500,
      },
    );
  }
}

export async function POST(request: NextApiRequest) {
  try {
    const connection = await getMySQLConnection();
    const { sensor_id, value } = await new Response(request.body).json();
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
      { message: "Something went wrong while adding the reading" },
      {
        status: 500,
      },
    );
  }
}

export async function PATCH(request: NextApiRequest) {
  try {
    const connection = await getMySQLConnection();
    const { sensor_id, value } = await new Response(request.body).json();
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
      { message: "Something went wrong while updating the reading" },
      {
        status: 500,
      },
    );
  }
}