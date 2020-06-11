import Vue from 'vue'

export const SET_TOKEN = 'auth/SET_TOKEN'
export const SET_REFRESH_TOKEN = 'auth/SET_REFRESH_TOKEN'
export const SET_META = 'auth/SET_META'
export const SET_USER_NAME = 'auth/SET_USER_NAME'
export const SET_USER_EMAIL = 'auth/SET_USER_EMAIL'
export const SET_USER_PAY_ID = 'auth/SET_USER_PAY_ID'

export default {
  [SET_TOKEN](state, payload) {
    state.token = payload
  },
  [SET_REFRESH_TOKEN](state, payload) {
    state.refreshToken = payload
  },
  [SET_META](state, payload) {
    state.meta = payload
  },
  [SET_USER_NAME](state, payload) {
    Vue.set(state.user, 'name', payload)
  },
  [SET_USER_EMAIL](state, payload) {
    Vue.set(state.user, 'email', payload)
  },
  [SET_USER_PAY_ID](state, payload) {
    Vue.set(state.user, 'payId', payload)
  },
}
