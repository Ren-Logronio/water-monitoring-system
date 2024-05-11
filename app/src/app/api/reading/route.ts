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
    const [result]: any = await connection.query(
      "UPDATE `readings` SET `value` = ?, `recorded_at` = ? WHERE `reading_id` = ?",
      [value, recorded_at, reading_id]
    );
    // const [readings]: any = await connection.query(
    //   "SELECT * FROM `readings` WHERE `reading_id` = ?",
    //   [reading_id]
    // );
    // const reading = readings[0];
    // const [pondParameters]: any = await connection.query(
    //   "SELECT * FROM `view_pond_parameters` WHERE `parameter_id` = ?",
    //   [reading.parameter_id]
    // );
    // const [thresholds]: any = await connection.query(
    //   "SELECT * FROM `parameter_thresholds` WHERE `parameter` = ?",
    //   [pondParameters[0].parameter]
    // );
    // const [farmers]: any = await connection.query(
    //   "SELECT `user_id` FROM `view_farmer_ponds` WHERE `pond_id` = ?",
    //   [pondParameters[0].pond_id]
    // );
    // const [readingNotifications]: any = await connection.query(
    //   "SELECT * FROM `view_reading_notifications` WHERE `reading_id` = ?",
    //   [reading_id]
    // );
    // readingNotifications.forEach(async (readingNotificiation: any) => { 
    //   switch (readingNotificiation.type) {
    //     case "LT":
    //           if (!(Number(value) < (readingNotificiation.target + readingNotificiation.error))) {
    //             console.log("Amending reading notification:", pondParameters[0].parameter, value);
    //             await connection.query("DELETE FROM `reading_notifications` WHERE `threshold_id` = ? AND reading_id = ?", [readingNotificiation.threshold_id, reading_id]);
    //           }
    //           break;
    //       case "GT":
    //           if (!(Number(value) > (readingNotificiation.target - readingNotificiation.error))) {
    //             console.log("Amending reading notification:", pondParameters[0].parameter, value);
    //             await connection.query("DELETE FROM `reading_notifications` WHERE `threshold_id` = ? AND reading_id = ?", [readingNotificiation.threshold_id, reading_id]);
    //           }
    //           break;
    //       case "EQ":
    //           if (!(Number(value) > (readingNotificiation.target - readingNotificiation.error) && Number(value) < (readingNotificiation.value + readingNotificiation.error))) {
    //             console.log("Amending reading notification:", pondParameters[0].parameter, value);
    //             await connection.query("DELETE FROM `reading_notifications` WHERE `threshold_id` = ? AND reading_id = ?", [readingNotificiation.threshold_id, reading_id]);
    //           }
    //           break;
    //       default:
    //           break;
    //   }
    // }); 

  //   thresholds.forEach((threshold: any) => {
  //     switch (threshold.type) {
  //         case "LT":
  //             if (Number(value) < (threshold.target + threshold.error)) {
  //                 console.log("Threshold LT breached:", pondParameters[0].parameter, value);
  //                 farmers.forEach(async (farmer: any) => {
  //                     await connection.query("INSERT INTO `reading_notifications` (`user_id`, `threshold_id`, `reading_id`) VALUES (?, ?, ?)", [farmer.user_id, threshold.threshold_id, reading_id]);
  //                 });
  //             }
  //             break;
  //         case "GT":
  //             if (Number(value) > (threshold.target - threshold.error)) {
  //                 console.log("Threshold GT breached:", pondParameters[0].parameter, value);
  //                 farmers.forEach(async (farmer: any) => {
  //                     await connection.query("INSERT INTO `reading_notifications` (`user_id`, `threshold_id`, `reading_id`) VALUES (?, ?, ?)", [farmer.user_id, threshold.threshold_id, reading_id]);
  //                 });
  //             }
  //             break;
  //         case "EQ":
  //             if (Number(value) > (threshold.target - threshold.error) && Number(value) < (threshold.value + threshold.error)) {
  //                 console.log("Threshold EQ breached:", pondParameters[0].parameter, value);
  //                 farmers.forEach(async (farmer: any) => {
  //                     await connection.query("INSERT INTO `reading_notifications` (`user_id`, `threshold_id`, `reading_id`) VALUES (?, ?, ?)", [farmer.user_id, threshold.threshold_id, reading_id]);
  //                 });
  //             }
  //             break;
  //         default:
  //             break;
  //     }
  // });
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