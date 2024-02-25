import bcrypt from "bcrypt";
import { NextApiRequest } from "next";
import { NextResponse } from "next/server";
import getMySQLConnection from "@/db/mysql";
import { FieldPacket } from "mysql2";
import jwt from "jsonwebtoken";

export async function POST(request: NextApiRequest) {
  const connection = await getMySQLConnection();
  const { email, password } = await new Response(request.body).json();

  const [results, rows]: [any[], FieldPacket[]] = await connection.query(
    "SELECT * FROM users WHERE email = ? LIMIT 1",
    [email],
  );

  console.log({ results, rows });
  if (
    !results ||
    !results.length ||
    !results[0] ||
    !results[0].password ||
    !results[0].email ||
    results[0].email != email
  ) {
    return NextResponse.json(
      { success: false, message: "Invalid email or password" },
      {
        // bad request
        status: 400,
      },
    );
  }

  const passwordComparison = bcrypt.compareSync(password, results[0].password);
  if (passwordComparison) {
    const token = jwt.sign(
      { foo: "bar" },
      process.env.APP_PRIVATE_KEY || "mykey",
    );
    console.log("token:", token);
    return NextResponse.json({
      success: true,
      token,
      message: "Successfully signed in",
    });
  } else {
    return NextResponse.json(
      { success: false, message: "Invalid email or password" },
      {
        // bad request
        status: 400,
      },
    );
  }
}
