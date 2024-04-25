import getMySQLConnection from "@/db/mysql";
import { NextRequest, NextResponse } from "next/server";

export async function GET(request: NextRequest) {
    try {
        const parameter = request.nextUrl.searchParams.get('parameter');
        const connection = await getMySQLConnection();
        const [results]: any = await connection.query(
            "SELECT * FROM `parameter_thresholds` LEFT JOIN `parameter_list` ON `parameter_thresholds`.`parameter` = `parameter_list`.`parameter` WHERE ? IN (`parameter_thresholds`.`parameter`, `parameter_list`.`name`)",
            [parameter]
        );
        return NextResponse.json({ results }, { status: 200 });
    } catch (err: any) {
        return NextResponse.json(
            { message: err.message || "Something went wrong while getting the notification" },
            {
                status: 500,
            },
        );
    }
}