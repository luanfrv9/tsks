'use server'
import {SignJWT} from 'jose'
import {TextEncoder} from 'util'
global.TextEncoder = TextEncoder

const REFRESH_TOKEN_KEY = process.env.REFRESH_TOKEN_KEY
const refreshKey = new TextEncoder().encode(REFRESH_TOKEN_KEY)

export async function createRefreshToken(email) {
  return new SignJWT({email})
    .setProtectedHeader({alg: 'HS256'})
    .setExpirationTime('10h')
    .sign(refreshKey)
}
