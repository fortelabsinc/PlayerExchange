import {
  setLocalStorageToken,
  deleteLocalStorageToken,
} from '../../localStorage'
import {
  SET_TOKEN,
  SET_REFRESH_TOKEN,
  SET_META,
  SET_USER_NAME,
  SET_USER_EMAIL,
  SET_USER_PAYID,
} from './mutations'
import { clearApiAuthToken, setApiAuthToken } from '../../apiAxios'

export const ActionLogin = ({ commit }, payload) => {
  const { token, refreshToken, meta, user } = payload

  setApiAuthToken(token)
  setLocalStorageToken(token)

  commit(SET_TOKEN, token)
  commit(SET_REFRESH_TOKEN, refreshToken)
  commit(SET_META, meta)
  commit(SET_USER_NAME, user.name)
  commit(SET_USER_EMAIL, user.email)
  commit(SET_USER_PAYID, user.payId)
}

export const ActionLogout = ({ commit }) => {
  clearApiAuthToken()
  deleteLocalStorageToken()

  commit(SET_TOKEN, '')
  commit(SET_REFRESH_TOKEN, '')
  commit(SET_META, '')
  commit(SET_USER_NAME, '')
  commit(SET_USER_EMAIL, '')
  commit(SET_USER_PAYID, '')
}
