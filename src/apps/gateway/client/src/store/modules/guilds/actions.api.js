import apiAxios from '../../apiAxios'
import { apiResponseHandler, apiErrorHandler } from '../../utils/api'
import {
  GUILDS_LIST_SET,
  GUILDS_LIST_ADD,
  GUILDS_LIST_EDIT,
  GUILDS_LIST_REMOVE,
  GUILDS_LIST_SET_ITEMS_PAGE,
  GUILD_MEMBERS_LIST_SET,
  GUILD_MEMBERS_LIST_ADD,
  GUILD_MEMBERS_LIST_REMOVE,
} from './mutations'

export const ApiActionFetchAllGuilds = ({ commit }) =>
  apiAxios
    .get('/guild')
    .then((response) =>
      apiResponseHandler(response).then(({ payload }) => {
        commit(GUILDS_LIST_SET, payload)
        return { payload }
      })
    )
    .catch(apiErrorHandler)

export const ApiActionGetGuildsPage = ({ commit }, { page, count }) =>
  apiAxios
    .get(`/guild/page/${page}/${count}`)
    .then((response) =>
      apiResponseHandler(response).then(({ payload }) => {
        commit(GUILDS_LIST_SET, payload.list)
        commit(GUILDS_LIST_SET_ITEMS_PAGE, count)
        return { payload }
      })
    )
    .catch(apiErrorHandler)

export const ApiActionGetGuildById = ({ commit }, { guild_id }) =>
  apiAxios
    .get(`/guild/${guild_id}`)
    .then((response) =>
      apiResponseHandler(response).then(({ payload }) => {
        commit(GUILDS_LIST_ADD, payload)
        return { payload }
      })
    )
    .catch(apiErrorHandler)

export const ApiActionFetchGuildMembers = ({ commit }, { guild_id }) =>
  apiAxios
    .get(`/guild/${guild_id}/members`)
    .then((response) =>
      apiResponseHandler(response).then(({ payload }) => {
        commit(GUILD_MEMBERS_LIST_SET, { guild_id, members: payload })
        return { payload }
      })
    )
    .catch(apiErrorHandler)

export const ApiActionCreateGuild = (
  { commit },
  { name, imageUrl, description, members }
) =>
  apiAxios
    .post('/guild', { name, imageUrl, description, members })
    .then((response) =>
      apiResponseHandler(response).then(({ payload }) => {
        commit(GUILDS_LIST_ADD, { name, imageUrl, guild_id: payload })
        return { payload }
      })
    )
    .catch(apiErrorHandler)

export const ApiActionAddGuildMember = ({ commit }, { guild_id, user_id }) =>
  apiAxios
    .post(`/guild/${guild_id}/members`, { guild_id, user_id })
    .then((response) =>
      apiResponseHandler(response).then(({ payload }) => {
        commit(GUILD_MEMBERS_LIST_ADD, { guild_id, member: payload })
        return { payload }
      })
    )
    .catch(apiErrorHandler)

export const ApiActionDeleteGuild = ({ commit }, { guild_id }) =>
  apiAxios
    .delete(`/guild/${guild_id}`)
    .then((response) =>
      apiResponseHandler(response).then(({ payload }) => {
        commit(GUILDS_LIST_REMOVE, guild_id)
        return { payload }
      })
    )
    .catch(apiErrorHandler)

export const ApiActionRemoveGuildMember = ({ commit }, { guild_id, user_id }) =>
  apiAxios
    .delete(`/guild/${guild_id}/member/${user_id}`)
    .then((response) =>
      apiResponseHandler(response).then(({ payload }) => {
        commit(GUILD_MEMBERS_LIST_REMOVE, { guild_id, user_id })
        return { payload }
      })
    )
    .catch(apiErrorHandler)

export const ApiActionEditGuild = (
  { commit },
  { guild_id, path, prop, value }
) =>
  apiAxios
    .post(`/guild/${guild_id}/${path}`, { id: guild_id, [prop]: value })
    .then((response) =>
      apiResponseHandler(response).then(({ payload }) => {
        commit(GUILDS_LIST_EDIT, { guild_id, [prop]: value })
        return { payload }
      })
    )
    .catch(apiErrorHandler)

export const ApiActionEditGuildName = (context, { guild_id, name }) =>
  ApiActionEditGuild(context, {
    guild_id,
    path: 'name',
    prop: 'name',
    value: name,
  })

export const ApiActionEditGuildRevueSplit = (
  context,
  { guild_id, revueSplit }
) =>
  ApiActionEditGuild(context, {
    guild_id,
    path: 'revueSplit',
    prop: 'revueSplit',
    value: revueSplit,
  })

export const ApiActionEditGuildImageUrl = (context, { guild_id, imageUrl }) =>
  ApiActionEditGuild(context, {
    guild_id,
    path: 'imageUrl',
    prop: 'imageUrl',
    value: imageUrl,
  })
