import apiAxios from '../../apiAxios'
import { get } from 'lodash'

export const ApiActionFetchAllPostings = ({ dispatch }, { callback } = {}) => {
  apiAxios
    .get('/work/posting')
    .then((response) => {
      if (get(response, 'data.ok')) {
        const payload = get(response, 'data.ok')
        dispatch('work/ActionSetAllPostings', payload)

        callback && callback(true, get(response, 'data.ok'))
      } else {
        callback && callback(false, get(response, 'data.error'))
      }
    })
    .catch((err) => {
      callback && callback(false, err)
    })
}

export const ApiActionFetchUserPostings = (
  { dispatch },
  { username, callback } = {}
) => {
  apiAxios
    .get(`/work/posting/${username}`)
    .then((response) => {
      if (get(response, 'data.ok')) {
        const payload = get(response, 'data.ok')
        dispatch('work/ActionAddPostings', payload)

        callback && callback(true, get(response, 'data.ok'))
      } else {
        callback && callback(false, get(response, 'data.error'))
      }
    })
    .catch((err) => {
      callback && callback(false, err)
    })
}

export const ApiActionFetchMyUserPostings = (context, payload) => {
  const username = get(context.rootState, 'auth.user.name')
  return ApiActionFetchUserPostings(context, { ...payload, username })
}

export const ApiActionCreatePosting = (
  { dispatch },
  { posting, callback } = {}
) => {
  apiAxios
    .post('/work/posting', posting)
    .then((response) => {
      if (get(response, 'data.ok')) {
        const payload = get(response, 'data.ok')
        dispatch('work/ActionAddPostings', payload)

        callback && callback(true, get(response, 'data.ok'))
      } else {
        callback && callback(false, get(response, 'data.error'))
      }
    })
    .catch((err) => {
      callback && callback(false, err)
    })
}

export const ApiActionDeletePosting = (
  { dispatch },
  { postingId, callback } = {}
) => {
  apiAxios
    .delete(`/work/posting/${postingId}`)
    .then((response) => {
      if (get(response, 'data.ok')) {
        dispatch('work/ActionRemovePostingsByIds', postingId)

        callback && callback(true, get(response, 'data.ok'))
      } else {
        callback && callback(false, get(response, 'data.error'))
      }
    })
    .catch((err) => {
      callback && callback(false, err)
    })
}

export const ApiActionDeleteAllPostings = ({ dispatch }, { callback } = {}) => {
  apiAxios
    .delete('/work/posting')
    .then((response) => {
      if (get(response, 'data.ok')) {
        dispatch('work/ActionDeleteAllPostings')

        callback && callback(true, get(response, 'data.ok'))
      } else {
        callback && callback(false, get(response, 'data.error'))
      }
    })
    .catch((err) => {
      callback && callback(false, err)
    })
}
