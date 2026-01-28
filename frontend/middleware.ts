import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";

export function middleware(request: NextRequest) {
  const { pathname } = request.nextUrl;

//   const isLoggedIn = request.cookies.get("auth-token");
  const isLoggedIn = true

  const isAuthPage =
    pathname.startsWith("/signin") ||
    pathname.startsWith("/signup");

  // 🔒 Not logged in → block protected routes
  if (!isLoggedIn && !isAuthPage) {
    return NextResponse.redirect(new URL("/signin", request.url));
  }

  // 🔁 Logged in → block auth pages
  if (isLoggedIn && isAuthPage) {
    return NextResponse.redirect(new URL("/dashboard", request.url));
  }

  return NextResponse.next();
}

export const config = {
  matcher: [
    "/((?!_next|favicon.ico|images|icons).*)",
  ],
};
