import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";
import { verify } from "@/utils/Jwt";

export async function middleware(request: NextRequest) {
  const requestHeaders = new Headers(request.headers)
  const cookieToken = request.cookies.get("token")?.value;

  if (["/signin", "/"].includes(request.nextUrl.pathname) && !request.nextUrl.searchParams.has("signout") && cookieToken) {
    return NextResponse.redirect(new URL("/dashboard", request.url));
  }
  
  if (cookieToken) {
    verify(cookieToken).then(async (res) => {
      if(!res) {
        return NextResponse.redirect(new URL("/signin?signout", request.url));
      }
      const { exp } = res;
      const now = Math.floor(Date.now() / 1000);
      if (exp && exp < now) {
        return NextResponse.redirect(new URL("/signin?signout", request.url));
      } else {
        return NextResponse.next();
      }
    })
  }

  if (!cookieToken && !(request.nextUrl.pathname === "/signin")) {
    return NextResponse.redirect(new URL("/signin", request.url));
  }
}

export const config = {
  matcher: ["/:path", "/signin", "/api/user/:path", "/dashboard", "/dashboard/:path"],
};
