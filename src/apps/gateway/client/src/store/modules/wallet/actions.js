import { uniqBy, castArray, filter, includes } from 'lodash'
import { SET_BALANCES } from './mutations'

export const ActionSetBalances = ({ commit }, payload) => {
  commit(SET_BALANCES, payload)
}

export const ActionDeleteBalances = ({ commit }) => {
  commit(SET_BALANCES, [])
}

export const ActionAddBalances = ({ commit, state }, payload) => {
  const newBalances = uniqBy(
    [...state.balances, ...castArray(payload)],
    'balance_id'
  )
  commit(SET_BALANCES, newBalances)
}

export const ActionRemoveBalancesByIds = ({ commit, state }, payload) => {
  const newBalances = filter(
    state.postings,
    (balance) => !includes(castArray(payload), balance.balance_id)
  )
  commit(SET_BALANCES, newBalances)
}
