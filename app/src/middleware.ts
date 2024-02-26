import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";



export function middleware(request: NextRequest) {
  const cookieToken = request.cookies.get("token");

  if (request.nextUrl.pathname === "/signin" && !request.nextUrl.searchParams.has("signout") && cookieToken) {
    return NextResponse.redirect(new URL("/dashboard", request.url));
  }

  if (!cookieToken && !(request.nextUrl.pathname === "/signin")) {
    return NextResponse.redirect(new URL("/signin", request.url));
  }
}

export const config = {
  matcher: ["/signin", "/api/user/:path", "/dashboard", "/dashboard/:path"],
};
