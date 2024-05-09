import getMySQLConnection from "@/db/mysql";
import moment from "moment";
import { NextRequest, NextResponse } from "next/server";

export async function GET(request: NextRequest) {
    try {
      const parameter_id = request.nextUrl.searchParams.get('parameter_id');
      const connection = await getMySQLConnection();
      const [results, rows]: [results: any[], rows: any[]] = await connection.query(
        "SELECT * FROM `readings` WHERE `parameter_id` = ?",
        [parameter_id]
      );
      const sortedByTime = results.sort((a, b) => moment(b.recorded_at).diff(moment(a.recorded_at)));
      return NextResponse.json(
        { result: { ...sortedByTime[0], previous_value: sortedByTime[1].value } },
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