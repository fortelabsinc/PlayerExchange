import apiAxios from '../../apiAxios'
import { apiResponseHandler, apiErrorHandler } from '../../utils/api'
import {
  APPS_LIST_SET,
  APPS_LIST_ADD,
  APPS_LIST_EDIT,
  APPS_LIST_REMOVE,
  APPS_LIST_SET_ITEMS_PAGE,
} from './mutations'

export const ApiActionFetchAllApps = ({ commit }) =>
  apiAxios
    .get('/app')
    .then((response) =>
      apiResponseHandler(response).then(({ payload }) => {
        commit(APPS_LIST_SET, payload)
        return { payload }
      })
    )
    .catch(apiErrorHandler)

export const ApiActionGetAppsPage = ({ commit }, { page, count }) =>
  apiAxios
    .get(`/app/page/${page}/${count}`)
    .then((response) =>
      apiResponseHandler(response).then(({ payload }) => {
        commit(APPS_LIST_SET, payload.list)
        commit(APPS_LIST_SET_ITEMS_PAGE, count)
        return { payload }
      })
    )
    .catch(apiErrorHandler)

export const ApiActionGetAppById = ({ commit }, { app_id }) =>
  apiAxios
    .get(`/app/${app_id}`)
    .then((response) =>
      apiResponseHandler(response).then(({ payload }) => {
        commit(APPS_LIST_ADD, payload)
        return { payload }
      })
    )
    .catch(apiErrorHandler)

export const ApiActionCreateApp = (
  { commit },
  { name, imageUrl, revueSplit }
) =>
  apiAxios
    .post('/app', { name, imageUrl, revueSplit })
    .then((response) =>
      apiResponseHandler(response).then(({ payload }) => {
        commit(APPS_LIST_ADD, { name, imageUrl, revueSplit, app_id: payload })
        return { payload }
      })
    )
    .catch(apiErrorHandler)

export const ApiActionDeleteApp = ({ commit }, { app_id }) =>
  apiAxios
    .delete(`/app/${app_id}`)
    .then((response) =>
      apiResponseHandler(response).then(({ payload }) => {
        commit(APPS_LIST_REMOVE, app_id)
        return { payload }
      })
    )
    .catch(apiErrorHandler)

export const ApiActionEditApp = ({ commit }, { app_id, path, prop, value }) =>
  apiAxios
    .post(`/app/${app_id}/${path}`, { id: app_id, [prop]: value })
    .then((response) =>
      apiResponseHandler(response).then(({ payload }) => {
        commit(APPS_LIST_EDIT, { app_id, [prop]: value })
        return { payload }
      })
    )
    .catch(apiErrorHandler)

export const ApiActionEditAppName = (context, { app_id, name }) =>
  ApiActionEditApp(context, {
    app_id,
    path: 'name',
    prop: 'name',
    value: name,
  })

export const ApiActionEditAppRevueSplit = (context, { app_id, revueSplit }) =>
  ApiActionEditApp(context, {
    app_id,
    path: 'revueSplit',
    prop: 'revueSplit',
    value: revueSplit,
  })

export const ApiActionEditAppImageUrl = (context, { app_id, imageUrl }) =>
  ApiActionEditApp(context, {
    app_id,
    path: 'imageUrl',
    prop: 'imageUrl',
    value: imageUrl,
  })
