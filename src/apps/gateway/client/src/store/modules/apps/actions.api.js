import apiAxios from '../../apiAxios'
import { apiResponseHandler, apiErrorHandler } from '../../utils/api'
import {
  APPS_LIST_SET,
  APPS_LIST_ADD,
  APPS_LIST_EDIT,
  APPS_LIST_BALANCE,
  APPS_LIST_REMOVE,
  APPS_LIST_SET_ITEMS_PAGE,
  APPS_LIST_PAY,
  APPS_NAME_SET,
} from './mutations'

export const ApiActionFetchAllApps = ({ commit }) =>
  apiAxios
    .get('/game')
    .then((response) =>
      apiResponseHandler(response).then(({ payload }) => {
        commit(APPS_LIST_SET, payload)
        return { payload }
      })
    )
    .catch(apiErrorHandler)

export const ApiActionFetchAllAppNames = ({ commit }) =>
  apiAxios
    .get('/game/names')
    .then((response) =>
      apiResponseHandler(response).then(({ payload }) => {
        commit(APPS_NAME_SET, payload)
        return { payload }
      })
    )
    .catch(apiErrorHandler)

export const ApiActionGetAppsPage = ({ commit }, { page, count }) =>
  apiAxios
    .get(`/game/page/${page}/${count}`)
    .then((response) =>
      apiResponseHandler(response).then(({ payload }) => {
        commit(APPS_LIST_SET, payload.list)
        commit(APPS_LIST_SET_ITEMS_PAGE, count)
        return { payload }
      })
    )
    .catch(apiErrorHandler)

export const ApiActionGetAppById = ({ commit }, { game_id }) =>
  apiAxios
    .get(`/game/${game_id}`)
    .then((response) =>
      apiResponseHandler(response).then(({ payload }) => {
        commit(APPS_LIST_ADD, payload)
        return { payload }
      })
    )
    .catch(apiErrorHandler)

export const ApiActionCreateApp = (
  { commit },
  { name, imageUrl, fee, description }
) =>
  apiAxios
    .post('/game', { name, image: imageUrl, fee, description })
    .then((response) =>
      apiResponseHandler(response).then(({ payload }) => {
        commit(APPS_LIST_ADD, {
          name,
          imageUrl,
          fee,
          description,
          game_id: payload,
        })
        return { payload }
      })
    )
    .catch(apiErrorHandler)

export const ApiActionDeleteApp = ({ commit }, { game_id }) =>
  apiAxios
    .delete(`/game/${game_id}`)
    .then((response) =>
      apiResponseHandler(response).then(({ payload }) => {
        commit(APPS_LIST_REMOVE, game_id)
        return { payload }
      })
    )
    .catch(apiErrorHandler)

export const ApiActionBalanceApp = ({ commit }, { game_id }) =>
  apiAxios
    .get(`/game/${game_id}/balance`)
    .then((response) =>
      apiResponseHandler(response).then(({ payload }) => {
        commit(APPS_LIST_BALANCE, payload)
        return { payload }
      })
    )
    .catch(apiErrorHandler)

export const ApiActionEditApp = ({ commit }, { game_id, path, prop, value }) =>
  apiAxios
    .post(`/game/${game_id}/${path}`, { id: game_id, [prop]: value })
    .then((response) =>
      apiResponseHandler(response).then(({ payload }) => {
        commit(APPS_LIST_EDIT, { game_id, [prop]: value })
        return { payload }
      })
    )
    .catch(apiErrorHandler)

export const ApiActionEditAppName = (context, { game_id, name }) =>
  ApiActionEditApp(context, {
    game_id,
    path: 'name',
    prop: 'name',
    value: name,
  })

export const ApiActionEditAppOwner = (context, { game_id, revueSplit }) =>
  ApiActionEditApp(context, {
    game_id,
    path: 'owner',
    prop: 'owner',
    value: revueSplit,
  })

export const ApiActionEditAppImageUrl = (context, { game_id, imageUrl }) =>
  ApiActionEditApp(context, {
    game_id,
    path: 'image',
    prop: 'image',
    value: imageUrl,
  })

export const ApiActionEditAppDescription = (
  context,
  { game_id, description }
) =>
  ApiActionEditApp(context, {
    game_id,
    path: 'description',
    prop: 'description',
    value: description,
  })

export const ApiActionEditAppMeta = (context, { game_id, meta }) =>
  ApiActionEditApp(context, {
    game_id,
    path: 'meta',
    prop: 'meta',
    value: meta,
  })

export const ApiActionPayOutApp = ({ commit }, { game_id, type, amount }) =>
  apiAxios
    .post(`/game/${game_id}/pay`, { type: type, amount: amount })
    .then((response) =>
      apiResponseHandler(response).then(({ payload }) => {
        commit(APPS_LIST_PAY, payload)
        return { payload }
      })
    )
    .catch(apiErrorHandler)
