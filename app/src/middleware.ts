import { NextResponse } from 'next/server'
import type { NextRequest } from 'next/server'
 
export function middleware(request: NextRequest) {
    const userToken = request.cookies.get('token');
    
    if (!userToken || !(userToken.value == '1234')) {
        return NextResponse.redirect(new URL('/', request.url))
    }
}
 
export const config = {
    matcher: ['/api/farm/:path', '/dashboard', '/dashboard/:path'],
}