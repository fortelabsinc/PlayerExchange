import { uniqBy, castArray, filter, includes, findIndex } from 'lodash'

export const GUILDS_LIST_SET = 'GUILDS_LIST_SET'
export const GUILDS_LIST_ADD = 'GUILDS_LIST_ADD'
export const GUILDS_LIST_EDIT = 'GUILDS_LIST_EDIT'
export const GUILDS_LIST_REMOVE = 'GUILDS_LIST_REMOVE'
export const GUILDS_LIST_SET_ITEMS_PAGE = 'GUILDS_LIST_SET_ITEMS_PAGE'
// export const GUILD_MEMBERS_LIST_SET = 'GUILD_MEMBERS_LIST_SET'
// export const GUILD_MEMBERS_LIST_ADD = 'GUILD_MEMBERS_LIST_ADD'
// export const GUILD_MEMBERS_LIST_REMOVE = 'GUILD_MEMBERS_LIST_REMOVE'
export const GUILD_LIST_BALANCE = 'GUILD_LIST_BALANCE'
export const GUILD_LIST_PAY = 'GUILD_LIST_PAY'

export default {
  [GUILDS_LIST_SET](state, payload) {
    state.list = payload
  },
  [GUILD_LIST_BALANCE](state, payload) {
    state.balance = payload
  },
  [GUILDS_LIST_ADD](state, payload) {
    state.list = uniqBy([...castArray(payload), ...state.list], 'guild_id')
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
  // [GUILD_MEMBERS_LIST_SET](state, payload) {
  //   const guild = find(
  //     state.list,
  //     ({ guild_id }) => guild_id === payload.guild_id
  //   )
  //   if (guild) {
  //     guild.members = payload.members
  //   }
  // },
  // [GUILD_MEMBERS_LIST_ADD](state, payload) {
  //   const guild = find(
  //     state.list,
  //     ({ guild_id }) => guild_id === payload.guild_id
  //   )
  //   if (guild) {
  //     guild.members = uniqBy(
  //       [...guild.members, ...castArray(payload.member)],
  //       'user_id'
  //     )
  //   }
  // },
  // [GUILD_MEMBERS_LIST_REMOVE](state, payload) {
  //   const guild = find(
  //     state.list,
  //     ({ guild_id }) => guild_id === payload.guild_id
  //   )
  //   if (guild) {
  //     guild.members = uniqBy(
  //       [...guild.members, ...castArray(payload.user_id)],
  //       'user_id'
  //     )
  //     guild.members = filter(
  //       guild.members,
  //       (member) => !includes(castArray(payload.user_id), member.user_id)
  //     )
  //   }
  // },
  [GUILD_LIST_PAY](state, payload) {
    console.log('State: ' + JSON.stringify(state))
    console.log('Payload: ' + JSON.stringify(payload))
  },
}
