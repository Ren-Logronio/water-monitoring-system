import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";

export function middleware(request: NextRequest) {
  const userToken = request.cookies.get("token");

  console.log("Path:", request.nextUrl.pathname);

  if (request.nextUrl.pathname === "/" && userToken) {
    return NextResponse.redirect(new URL("/dashboard", request.url));
  }

  if (!userToken && !(request.nextUrl.pathname === "/")) {
    return NextResponse.redirect(new URL("/", request.url));
  }
}

export const config = {
  matcher: ["/", "/api/user/:path", "/dashboard", "/dashboard/:path"],
};
