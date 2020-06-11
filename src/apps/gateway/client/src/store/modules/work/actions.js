import { uniqBy, castArray, filter, includes } from 'lodash'
import { SET_ALL_POSTINGS } from './mutations'

export const ActionSetAllPostings = ({ commit }, payload) => {
  commit(SET_ALL_POSTINGS, payload)
}

export const ActionDeleteAllPostings = ({ commit }) => {
  commit(SET_ALL_POSTINGS, [])
}

export const ActionAddPostings = ({ commit, state }, payload) => {
  const newPostings = uniqBy(
    [...state.postings, ...castArray(payload)],
    'post_id'
  )
  commit(SET_ALL_POSTINGS, newPostings)
}

export const ActionRemovePostingsByIds = ({ commit, state }, payload) => {
  const newPostings = filter(
    state.postings,
    (posting) => !includes(castArray(payload), posting.post_id)
  )
  commit(SET_ALL_POSTINGS, newPostings)
}
