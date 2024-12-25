import {SignJWT} from 'jose'

const ACCESS_TOKEN_KEY = process.env.ACCESS_TOKEN_KEY
const accessKey = new TextEncoder().encode(ACCESS_TOKEN_KEY)

export async function createAccessToken(email) {
  return new SignJWT({email})
    .setProtectedHeader({alg: 'HS256'})
    .setExpirationTime('1h')
    .sign(accessKey)
}
