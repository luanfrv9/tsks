// useSignUp
//
// when signing up (call useSignUp)
// call service apiUserSignUp
//
// when sign up successfully
// return ApiUserSignUpSuccessType
//
// when sign up failed
// return ApiUserSignUpFailType

/*
ApiUserSignUpSuccessType
{
  ok,
  isReady
  data: {
    user,
    accessToken
  },
}

ApiUserSignUpFailType
{
  ok,
  isReady
  error: {
    message,
    statusCode
  },
}
*/
