import apiAxios, { setApiAuthToken } from '../../apiAxios'
import { get, isEmpty } from 'lodash'
import { getLocalStorageToken } from '../../localStorage'
import { getToken } from './getters'
import { apiResponseHandler, apiErrorHandler } from '../../utils/api'

export const ApiActionLogin = ({ dispatch }, { username, password }) =>
  apiAxios
    .post('/auth/login', { username, password })
    .then((response) =>
      apiResponseHandler(response).then(({ payload }) => {
        payload = {
          token: get(payload, 'access_token'),
          refreshToken: get(payload, 'refresh_token'),
          meta: get(payload, 'meta'),
          user: {
            name: username,
            payId: get(payload, 'payId'),
            userId: get(payload, 'user_id'),
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
      return Promise.resolve({ error: { message: 'No token found' } })
      // throw 'No token found'
    }
  }

  return apiAxios
    .get('/auth/check')
    .then((response) =>
      apiResponseHandler(response).then(({ payload }) => {
        payload = {
          token: getToken(state) || getLocalStorageToken(), //get(payload, 'access_token'),
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

export const ApiActionRegister = (_, { username, email, password }) =>
  apiAxios
    .post('/auth/register', {
      username,
      email,
      password,
      password_confirm: password,
      meta: {},
    })
    .then((response) => apiResponseHandler(response))
    .catch(apiErrorHandler)

export const ApiActionFetchAllUserNames = (_, { ids }) =>
  apiAxios
    .post('/auth/names', { ids })
    .then((response) =>
      apiResponseHandler(response).then(({ payload }) => {
        // commit(APPS_NAME_SET, payload)
        return { payload }
      })
    )
    .catch(apiErrorHandler)
