import { uniqBy, castArray, filter, includes, findIndex } from 'lodash'

export const POSTINGS_LIST_SET = 'POSTINGS_LIST_SET'
export const POSTINGS_LIST_ADD = 'POSTINGS_LIST_ADD'
export const POSTINGS_LIST_EDIT = 'POSTINGS_LIST_EDIT'
export const POSTINGS_LIST_REMOVE = 'POSTINGS_LIST_REMOVE'
export const POSTINGS_LIST_SET_ITEMS_PAGE = 'POSTINGS_LIST_SET_ITEMS_PAGE'

export default {
  [POSTINGS_LIST_SET](state, payload) {
    state.list = payload
  },
  [POSTINGS_LIST_ADD](state, payload) {
    state.list = uniqBy([...state.list, ...castArray(payload)], 'post_id')
  },
  [POSTINGS_LIST_EDIT](state, payload) {
    const postIndex = findIndex(
      state.list,
      ({ post_id }) => post_id === payload.post_id
    )
    if (postIndex >= 0) {
      const newList = [...state.list]
      newList.splice(postIndex, 1, {
        ...state.list[postIndex],
        ...payload,
      })
      state.list = newList
    }
  },
  [POSTINGS_LIST_REMOVE](state, payload) {
    state.list = filter(
      state.list,
      (posting) => !includes(castArray(payload), posting.post_id)
    )
  },
  [POSTINGS_LIST_SET_ITEMS_PAGE](state, payload) {
    state.itemsPerPage = payload
  },
}
