import {
  createAccessToken,
  createRefreshToken,
  validateEmail,
} from '../../../../utils'
import {selectUsersByEmail, createUser} from '../../../db/'

export async function apiUserSignup({email, password}) {
  if (!email) {
    return {error: {status_code: 400, message: '400 Bad Request'}, ok: false}
  }

  if (!password) {
    return {error: {status_code: 400, message: '400 Bad Request'}, ok: false}
  }

  const isValidEmail = validateEmail(email)

  if (!isValidEmail) {
    return {error: {status_code: 400, message: '400 Bad Request'}, ok: false}
  }

  const usersByEmail = await selectUsersByEmail(email)

  if (usersByEmail.length) {
    return {error: {status_code: 409, message: '409 Conflict'}, ok: false}
  }

  const accessToken = await createAccessToken(email)
  const refreshToken = await createRefreshToken(email)

  // TODO: research about password digest (rails) how to manage passwords
  const user = await createUser({email, passwordDigest: password, refreshToken})

  if (user) {
    return {
      ok: true,
      data: {
        user,
        access_token: accessToken,
        refresh_token: refreshToken
      }
    }
  }

  return {error: {status_code: 422, message: '422 Unprocessable Entity'}, ok: false}
}
