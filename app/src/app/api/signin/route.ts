import bcrypt from "bcrypt";
import { NextApiRequest } from "next";
import { NextRequest, NextResponse } from "next/server";
import getMySQLConnection from "@/db/mysql";
import { sign } from '@/utils/Jwt'
// import jwt from "jsonwebtoken";

export async function POST(request: NextRequest) {
  const connection = await getMySQLConnection();
  const { email, password } = await request.json();

  const [results, rows]: [any[], any[]] = await connection.query(
    "SELECT `user_id`, `email`, `password`, `firstname`, `lastname` FROM users WHERE email = ? LIMIT 1",
    [email],
  );

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
    const { user_id, email: user_email } = results[0];
    const token = await sign(JSON.stringify({ user_id, user_email }));
    return NextResponse.json({
      success: true,
      token,
      firstname: results[0].firstname,
      lastname: results[0].lastname,
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
