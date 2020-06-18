import { uniqBy, castArray, filter, includes, findIndex } from 'lodash'

export const APPS_LIST_SET = 'APPS_LIST_SET'
export const APPS_LIST_ADD = 'APPS_LIST_ADD'
export const APPS_LIST_EDIT = 'APPS_LIST_EDIT'
export const APPS_LIST_REMOVE = 'APPS_LIST_REMOVE'
export const APPS_LIST_SET_ITEMS_PAGE = 'APPS_LIST_SET_ITEMS_PAGE'

export default {
  [APPS_LIST_SET](state, payload) {
    state.list = payload
  },
  [APPS_LIST_ADD](state, payload) {
    state.list = uniqBy([...state.list, ...castArray(payload)], 'app_id')
  },
  [APPS_LIST_EDIT](state, payload) {
    const appIndex = findIndex(
      state.list,
      ({ app_id }) => app_id === payload.app_id
    )
    if (appIndex >= 0) {
      const newList = [...state.list]
      newList.splice(appIndex, 1, { ...state.list[appIndex], ...payload })
      state.list = newList
    }
  },
  [APPS_LIST_REMOVE](state, payload) {
    state.list = filter(
      state.list,
      (app) => !includes(castArray(payload), app.app_id)
    )
  },
  [APPS_LIST_SET_ITEMS_PAGE](state, payload) {
    state.itemsPerPage = payload
  },
}
