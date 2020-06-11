export const SET_BALANCES = 'wallet/SET_BALANCES'

export default {
  [SET_BALANCES](state, payload) {
    state.balances = payload
  },
}
