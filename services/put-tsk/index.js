import { getCurrentAuthTokenAtBrowser } from "../../utils"

const {NEXT_PUBLIC_API_URL} = process.env

// TODO: handle catch return
export async function putTsk({tskId, tsk}) {
  const apiToken = getCurrentAuthTokenAtBrowser()

  const res = await fetch(`${NEXT_PUBLIC_API_URL}/tsks/${tskId}`, {
    headers: {
      'content-type': 'application/json',
      'Access-Control-Allow-Origin': '*',
      authorization: `Bearer ${apiToken}`,
    },
    method: 'PUT',
    body: JSON.stringify({tsk})
  })
    .then(r => r.json())
    .catch(e => e)

  if(!res.ok) {
    const {ok, message} = res
    return {ok, error: {message: message}, data: null}
  }

  const {ok, tsk: updatedTsk} = res
  return {ok, data: {tsk: updatedTsk}, error: null}
}