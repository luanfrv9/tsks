import {apiUserSignup} from '../../services'

export default async function handler(req, res) {
  const {email, password} = req.body
  const {data, error, ok} = await apiUserSignup({email, password})
  const {status_code} = error
  const response = ok ? {ok, data} : {ok, error}

  return res.status(status_code).json(response)
}
