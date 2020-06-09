import { get } from 'lodash'
import apiAxios from '../../apiAxios'
import { apiResponseHandler, apiErrorHandler } from '../../utils/api'
import {
  POSTINGS_LIST_SET,
  POSTINGS_LIST_ADD,
  POSTINGS_LIST_REMOVE,
} from './mutations'

export const ApiActionFetchAllPostings = ({ commit }) =>
  apiAxios
    .get('/work/posting')
    .then((response) =>
      apiResponseHandler(response).then(({ payload }) => {
        commit(POSTINGS_LIST_SET, payload)
        return { payload }
      })
    )
    .catch(apiErrorHandler)

export const ApiActionFetchUserPostings = ({ commit }, { username }) =>
  apiAxios
    .get(`/work/posting/${username}`)
    .then((response) =>
      apiResponseHandler(response).then(({ payload }) => {
        commit(POSTINGS_LIST_ADD, payload)
        return { payload }
      })
    )
    .catch(apiErrorHandler)

export const ApiActionFetchMyUserPostings = (context, payload) => {
  const username = get(context.rootState, 'auth.user.name')
  return ApiActionFetchUserPostings(context, { ...payload, username })
}

export const ApiActionCreatePosting = ({ commit }, { posting }) =>
  apiAxios
    .post('/work/posting', posting)
    .then((response) =>
      apiResponseHandler(response).then(({ payload }) => {
        commit(POSTINGS_LIST_ADD, posting)
        return { payload }
      })
    )
    .catch(apiErrorHandler)

export const ApiActionDeletePosting = ({ commit }, { postingId }) =>
  apiAxios
    .delete(`/work/posting/${postingId}`)
    .then((response) =>
      apiResponseHandler(response).then(({ payload }) => {
        commit(POSTINGS_LIST_REMOVE, postingId)
        return { payload }
      })
    )
    .catch(apiErrorHandler)

export const ApiActionDeleteAllPostings = ({ commit }) =>
  apiAxios
    .delete('/work/posting')
    .then((response) =>
      apiResponseHandler(response).then(({ payload }) => {
        commit(POSTINGS_LIST_SET, [])
        return { payload }
      })
    )
    .catch(apiErrorHandler)
