import getMySQLConnection from "@/db/mysql";
import { NextRequest, NextResponse } from "next/server";

export async function GET(request: NextRequest) {
    try {
        const pond_id = request.nextUrl.searchParams.get('pond_id');
        const connection = await getMySQLConnection();
        const [pondFarm]: any = await connection.query(
            "SELECT `ponds`.`pond_id`, `ponds`.`latitude`, `ponds`.`longitude`, `ponds`.`name` AS `pond_name`, `farms`.`name` AS `farm_name`, `farms`.`address_street`, `farms`.`address_city`, `farms`.`address_city`, `farms`.`address_province` FROM `ponds` LEFT JOIN `farms` ON `ponds`.`farm_id` = `farms`.`farm_id` WHERE `ponds`.`pond_id` = ?",
            [pond_id]
        );
        console.log("RES:", pondFarm[0]);
        return NextResponse.json(
            {
                result: pondFarm[0],
            },
            {
                status: 200,
            },
        );
    } catch (error: any) {
        return NextResponse.json(
            { message: error.message || "An unknown error occurred"},
            {
                status: 500,
            },
        );
    }

}