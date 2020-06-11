import { get } from 'lodash'

export const apiResponseHandler = (response) => {
  const payload = get(response, 'data.ok')
  if (!payload) {
    const error = get(response, 'error')
    if (error) {
      throw error
    }
  }
  return Promise.resolve({ payload })
}

// TODO: Consider improve API error handler, log?, dispatch action?
export const apiErrorHandler = (error) => {
  console.log('Exception thrown: ' + error)
  return { error }
}
