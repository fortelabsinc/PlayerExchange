import { uniqBy, castArray, filter, includes, findIndex } from 'lodash'

export const GUILDS_LIST_SET = 'GUILDS_LIST_SET'
export const GUILDS_LIST_ADD = 'GUILDS_LIST_ADD'
export const GUILDS_LIST_EDIT = 'GUILDS_LIST_EDIT'
export const GUILDS_LIST_REMOVE = 'GUILDS_LIST_REMOVE'
export const GUILDS_LIST_SET_ITEMS_PAGE = 'GUILDS_LIST_SET_ITEMS_PAGE'

export default {
  [GUILDS_LIST_SET](state, payload) {
    state.list = payload
  },
  [GUILDS_LIST_ADD](state, payload) {
    state.list = uniqBy([...state.list, ...castArray(payload)], 'guild_id')
  },
  [GUILDS_LIST_EDIT](state, payload) {
    const guildIndex = findIndex(
      state.list,
      ({ guild_id }) => guild_id === payload.guild_id
    )
    if (guildIndex >= 0) {
      const newList = [...state.list]
      newList.splice(guildIndex, 1, { ...state.list[guildIndex], ...payload })
      state.list = newList
    }
  },
  [GUILDS_LIST_REMOVE](state, payload) {
    state.list = filter(
      state.list,
      (guild) => !includes(castArray(payload), guild.guild_id)
    )
  },
  [GUILDS_LIST_SET_ITEMS_PAGE](state, payload) {
    state.itemsPerPage = payload
  },
}
