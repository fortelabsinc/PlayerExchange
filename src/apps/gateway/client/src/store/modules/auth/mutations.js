import Vue from 'vue'

export const SET_TOKEN = 'SET_TOKEN'
export const SET_REFRESH_TOKEN = 'SET_REFRESH_TOKEN'
export const SET_META = 'SET_META'
export const SET_USER_NAME = 'SET_USER_NAME'
export const SET_USER_EMAIL = 'SET_USER_EMAIL'

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
}
