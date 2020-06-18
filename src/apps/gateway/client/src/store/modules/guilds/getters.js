import { find } from 'lodash'

export const getGuildsList = ({ list }) => list
export const getGuildById = ({ list }) => (id) =>
  find(list, ({ guild_id }) => guild_id === id)
export const getGuildsItemsPerPage = ({ itemsPerPage }) => itemsPerPage
