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

export async function POST(request: NextRequest) {
  try {
    const connection = await getMySQLConnection();
    const { sensor_id, value } = await request.json();
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

export async function PUT(request: NextRequest) {
  try {
    const connection = await getMySQLConnection();
    const { reading_id, value, recorded_at } = await request.json();
    const [result, fields] = await connection.query(
      "UPDATE `readings` SET `value` = ?, `recorded_at` = ? WHERE `reading_id` = ?",
      [value, recorded_at, reading_id]
    );
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

export async function PATCH(request: NextRequest) {
  try {
    const connection = await getMySQLConnection();
    const { sensor_id, value } = await request.json();
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

export async function DELETE(request: NextRequest) {
  try {
    const reading_id = request.nextUrl.searchParams.get('reading_id');
    const connection = await getMySQLConnection();
    await connection.query(
      "DELETE FROM `readings` WHERE `reading_id` = ?",
      [reading_id]
    );
    return NextResponse.json(
      { message: "Successfully deleted the sensor reading" },
      {
        status: 200,
      },
    );
  } catch (e) {
    console.log(e);
    return NextResponse.json(
      { message: "Something went wrong while deleting the sensor reading" },
      {
        status: 500,
      },
    );
  }
}