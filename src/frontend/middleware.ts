import { NextResponse } from 'next/server'
import type { NextRequest } from 'next/server'
import { v4 } from 'uuid';
 
export function middleware(request: NextRequest) {
  const response = NextResponse.next()

  // If the SESSIONID cookie is not set, generate a new UUID and set it
  if(!request.cookies.has('SESSIONID'))
    response.cookies.set('SESSIONID', v4())
 
  return response
}

// See "Matching Paths" below to learn more
export const config = {
  matcher: '/:path*',
}