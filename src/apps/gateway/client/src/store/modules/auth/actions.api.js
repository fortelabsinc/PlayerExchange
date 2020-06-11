import apiAxios, { setApiAuthToken } from '../../apiAxios'
import { get, isEmpty } from 'lodash'
import { getLocalStorageToken } from '../../localStorage'
import { getToken } from './getters'
import { apiResponseHandler, apiErrorHandler } from '../../utils/api'

export const ApiActionLogin = ({ dispatch }, { email, password }) =>
  apiAxios
    .post('/auth/login', { username: email, password })
    .then((response) =>
      apiResponseHandler(response).then(({ payload }) => {
        payload = {
          token: get(payload, 'access_token'),
          refreshToken: get(payload, 'refresh_token'),
          meta: get(payload, 'meta'),
          user: {
            name: email,
            email,
          },
        }

        dispatch('ActionLogin', payload)
        return { payload }
      })
    )
    .catch(apiErrorHandler)

export const ApiActionLogout = ({ dispatch }) => dispatch('ActionLogout')

export const ApiActionCheckAuth = ({ dispatch, state }) => {
  const token = getToken(state)
  if (!isEmpty(token)) {
    setApiAuthToken(token)
  } else {
    const localStorageToken = getLocalStorageToken()
    if (localStorageToken) {
      setApiAuthToken(localStorageToken)
    } else {
      throw 'No token found'
    }
  }

  return apiAxios
    .get('/auth/check')
    .then((response) =>
      apiResponseHandler(response).then(({ payload }) => {
        payload = {
          token: get(payload, 'access_token'),
          refreshToken: get(payload, 'refresh_token'),
          meta: get(payload, 'meta'),
          user: {
            name: get(payload, 'username'),
            email: get(payload, 'email'),
          },
        }

        dispatch('ActionLogin', payload)
        return { payload }
      })
    )
    .catch(apiErrorHandler)
}

export const ApiActionRegister = (_, { username, email, password }) => {
  apiAxios
    .post('/auth/register', {
      username: username,
      email: email,
      password: password,
      password_confirm: password,
      meta: {},
    })
    .then((response) => apiResponseHandler(response))
    .catch(apiErrorHandler)
}
