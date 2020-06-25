import { find } from 'lodash'

export const getGuildsList = ({ list }) => list
export const getGuildById = ({ list }) => (id) =>
  find(list, ({ guild_id }) => guild_id === id)
export const getGuildsItemsPerPage = ({ itemsPerPage }) => itemsPerPage
export const getGuildMembers = ({ list }) => (id) =>
  find(list, ({ guild_id }) => guild_id === id).members
export const getMembersItemsPerPage = ({ memberItemsPerPage }) =>
  memberItemsPerPage
export const getBalances = ({ balance }) => balance
