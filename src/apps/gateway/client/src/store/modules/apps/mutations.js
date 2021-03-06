import { uniqBy, castArray, filter, includes, findIndex } from 'lodash'

export const APPS_LIST_SET = 'APPS_LIST_SET'
export const APPS_LIST_ADD = 'APPS_LIST_ADD'
export const APPS_LIST_EDIT = 'APPS_LIST_EDIT'
export const APPS_LIST_REMOVE = 'APPS_LIST_REMOVE'
export const APPS_LIST_SET_ITEMS_PAGE = 'APPS_LIST_SET_ITEMS_PAGE'
export const APPS_LIST_BALANCE = 'APPS_LIST_BALANCE'
export const APPS_LIST_PAY = 'APPS_LIST_PAY'
export const APPS_NAME_SET = 'APPS_NAME_SET'

export default {
  [APPS_LIST_SET](state, payload) {
    state.list = payload
  },
  [APPS_LIST_BALANCE](state, payload) {
    state.balance = payload
  },
  [APPS_LIST_ADD](state, payload) {
    state.list = uniqBy([...castArray(payload), ...state.list], 'game_id')
  },
  [APPS_LIST_EDIT](state, payload) {
    const appIndex = findIndex(
      state.list,
      ({ game_id }) => game_id === payload.game_id
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
      (app) => !includes(castArray(payload), app.game_id)
    )
  },
  [APPS_LIST_SET_ITEMS_PAGE](state, payload) {
    state.itemsPerPage = payload
  },

  [APPS_NAME_SET](state, payload) {
    state.appNames = payload
  },

  [APPS_LIST_PAY](state, payload) {
    console.log('State: ' + JSON.stringify(state))
    console.log('Payload: ' + JSON.stringify(payload))
  },
}
