import { find } from 'lodash'

export const getAppsList = ({ list }) => list
export const getAppById = ({ list }) => (id) =>
  find(list, ({ game_id }) => game_id === id)
export const getAppsItemsPerPage = ({ itemsPerPage }) => itemsPerPage
export const getAppsNames = ({ appNames }) => appNames
export const getBalances = ({ balance }) => balance
