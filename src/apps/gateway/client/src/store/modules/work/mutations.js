export const SET_ALL_POSTINGS = 'work/SET_ALL_POSTINGS'

export default {
  [SET_ALL_POSTINGS](state, payload) {
    state.postings = payload
  },
}
