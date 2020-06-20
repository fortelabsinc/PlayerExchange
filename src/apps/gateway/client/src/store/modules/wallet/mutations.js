import { uniqBy, castArray, filter, includes, findIndex } from 'lodash'

export const BALANCE_LIST_SET = 'BALANCE_LIST_SET'
export const BALANCE_LIST_ADD = 'BALANCE_LIST_ADD'
export const BALANCE_LIST_EDIT = 'BALANCE_LIST_EDIT'
export const BALANCE_LIST_REMOVE = 'BALANCE_LIST_REMOVE'
export const BALANCE_LIST_SET_ITEMS_PAGE = 'BALANCE_LIST_SET_ITEMS_PAGE'

export default {
  [BALANCE_LIST_SET](state, payload) {
    state.list = payload
  },
  [BALANCE_LIST_ADD](state, payload) {
    state.list = uniqBy([...state.list, ...castArray(payload)], 'id')
  },
  [BALANCE_LIST_EDIT](state, payload) {
    const balanceIndex = findIndex(state.list, ({ id }) => id === payload.id)
    if (balanceIndex >= 0) {
      const newList = [...state.list]
      newList.splice(balanceIndex, 1, {
        ...state.list[balanceIndex],
        ...payload,
      })
      state.list = newList
    }
  },
  [BALANCE_LIST_REMOVE](state, payload) {
    state.list = filter(
      state.list,
      (posting) => !includes(castArray(payload), posting.id)
    )
  },
  [BALANCE_LIST_SET_ITEMS_PAGE](state, payload) {
    state.itemsPerPage = payload
  },
}
