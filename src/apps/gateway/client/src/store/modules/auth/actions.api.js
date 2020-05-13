import apiAxios, { setApiAuthToken } from '../api/apiAxios'
import { get, isEmpty } from 'lodash'
import { getLocalStorageToken } from '../../localStorage'
import { getToken } from './getters'

export const ApiActionLogin = ({ dispatch }, { email, password, callback }) => {
  apiAxios
    .post('/auth/login', { username: email, password })
    .then((response) => {
      if (get(response, 'data.ok')) {
        const payload = {
          token: get(response, 'data.ok.access_token'),
          refreshToken: get(response, 'data.ok.refresh_token'),
          meta: get(response, 'data.ok.meta'),
          user: {
            name: email,
            email,
            payId: get(response, 'data.ok.payId'),
          },
        }

        dispatch('auth/ActionLogin', payload)

        callback && callback(true, get(response, 'data.ok'))
      } else {
        callback && callback(false, get(response, 'data.error'))
      }
    })
}

export const ApiActionLogout = ({ dispatch }) => {
  // TODO: Call an API endpoint?
  dispatch('auth/ActionLogout')
}

export const ApiActionCheckAuth = ({ dispatch, state }, { callback } = {}) => {
  const token = getToken(state)
  if (!isEmpty(token)) {
    setApiAuthToken(token)
  } else {
    const localStorageToken = getLocalStorageToken()
    if (localStorageToken) {
      setApiAuthToken(localStorageToken)
    } else {
      callback && callback(false, 'No token found')
    }
  }

  apiAxios.post('/auth/check').then((response) => {
    if (get(response, 'data.ok')) {
      const payload = {
        token: get(response, 'data.ok.access_token'),
        refreshToken: get(response, 'data.ok.refresh_token'),
        meta: get(response, 'data.ok.meta'),
        user: {
          name: get(response, 'data.ok.username'),
          email: get(response, 'data.ok.email'),
          payId: get(response, 'data.ok.payId'),
        },
      }

      dispatch('auth/ActionLogin', payload)

      callback && callback(true, get(response, 'data.ok'))
    } else {
      callback && callback(false, get(response, 'data.error'))
    }
  })
}
