import {apiUserSignup} from '.'

import {selectUsersByEmail, createUser} from '../../../db'
jest.mock('../../../db')

describe('apiUserSignup', () => {
  describe('cannot without email', () => {
    let response = null

    beforeEach(async () => {
      response = await apiUserSignup({email: '', password: 's'})
    })

    it('returns status_code=400', () => {
      expect(response).toHaveProperty('status_code', 400)
    })

    it('returns message="400 Bad Request"', () => {
      expect(response).toHaveProperty('message', '400 Bad Request')
    })

    it('returns ok=false', () => {
      expect(response).toHaveProperty('ok', false)
    })
  })

  describe('cannot without password', () => {
    let response = null

    beforeEach(async () => {
      response = await apiUserSignup({email: 'aaa@bbb.ccc', password: ''})
    })

    it('returns status_code=400', () => {
      expect(response).toHaveProperty('status_code', 400)
    })

    it('returns message="400 Bad Request"', () => {
      expect(response).toHaveProperty('message', '400 Bad Request')
    })

    it('returns ok=false', () => {
      expect(response).toHaveProperty('ok', false)
    })
  })

  describe('cannot without valid email', () => {
    let response = null

    beforeEach(async () => {
      response = await apiUserSignup({email: 'random', password: 's'})
    })

    it('returns status_code=400', () => {
      expect(response).toHaveProperty('status_code', 400)
    })

    it('returns message="400 Bad Request"', () => {
      expect(response).toHaveProperty('message', '400 Bad Request')
    })

    it('returns ok=false', () => {
      expect(response).toHaveProperty('ok', false)
    })
  })

  describe('cannot without already registered email', () => {
    let response = null

    beforeEach(async () => {
      selectUsersByEmail.mockReturnValue([{}])
      response = await apiUserSignup({email: 'aaa@bbb.ccc', password: 's'})
    })

    it('returns status_code=409', () => {
      expect(response).toHaveProperty('status_code', 409)
    })

    it('returns message="409 Conflict"', () => {
      expect(response).toHaveProperty('message', '409 Conflict')
    })

    it('returns ok=false', () => {
      expect(response).toHaveProperty('ok', false)
    })
  })

  describe('signup succesfully', () => {
    let response = null

    beforeEach(() => {
      selectUsersByEmail.mockReturnValue([])
      response = apiUserSignup({email: 'aaa@bbb.ccc', pass: 's'})
    })

    it('returns status_code=201', () => {
      expect(response).toHaveProperty('status_code', 201)
    })

    it('returns message="201 Created"', () => {
      expect(response).toHaveProperty('message', '201 Created')
    })

    it('returns ok=true', () => {
      expect(response).toHaveProperty('ok', true)
    })

    // TODO: test response has user info such email
    it('returns user', () => {
      expect(response).toHaveProperty('user')
    })

    it('returns access token', () => {
      expect(response).toHaveProperty('access_token')
    })

    it('returns refresh token', () => {
      expect(response).toHaveProperty('refresh_token')
    })

    it('saves user on db', () => {
      expect(createUser).toHaveBeenCalled()
    })

    // TODO: called with refresh_token
    // it('saves refresh token on db', () => {
    //   expect(createUser).toHaveBeenCalledWith()
    // })
  })
})
