import { find } from 'lodash'

export const getAppsList = ({ list }) => list
export const getAppById = ({ list }) => (id) =>
  find(list, ({ app_id }) => app_id === id)
export const getAppsItemsPerPage = ({ itemsPerPage }) => itemsPerPage
export const getAppsNames = ({ appNames }) => appNames
