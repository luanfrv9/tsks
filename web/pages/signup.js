import {useState} from 'react'
import {useRouter} from 'next/router'
import Link from 'next/link'
import {
  Layout,
  UserForm,
  FlashMessage,
  SpacerSmall,
  Subtitle,
} from '../components'
import {setCurrentUserAtBrowser, setCurrentAuthTokenAtBrowser} from '../utils'
import {signUpUser} from '../services'

export default function SignUp() {
  const router = useRouter()
  const [reqError, setReqError] = useState(null)
  const [isLoading, setIsLoading] = useState(null)

  async function handleSubmit({email, password}) {
    setIsLoading(true)
    // TODO: call hook useSignUp
    const {ok, data, error, isReady} = await signUpUser({email, password})
    setIsLoading(!isReady)

    if (ok) {
      setCurrentUserAtBrowser(data.user)
      setCurrentAuthTokenAtBrowser(data.auth_token)
      return router.push('/tsks')
    }

    setReqError(error.message)
  }

  return (
    <Layout>
      <FlashMessage type='error' message={reqError} />
      <Subtitle value='signup' />
      <UserForm handleSubmit={handleSubmit} isLoading={isLoading} />
      <SpacerSmall />
      <Link href='/signin'>or signin to your account</Link>
    </Layout>
  )
}
