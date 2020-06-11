import apiAxios from '../../apiAxios'
import { get } from 'lodash'

export const ApiActionFetchBalances = ({ dispatch }, { callback } = {}) => {
  apiAxios
    .get('/wallet/balance')
    .then((response) => {
      if (get(response, 'data.ok')) {
        const payload = get(response, 'data.ok')
        dispatch('wallet/ActionSetBalances', payload)

        callback && callback(true, get(response, 'data.ok'))
      } else {
        callback && callback(false, get(response, 'data.error'))
      }
    })
    .catch((err) => {
      callback && callback(false, err)
    })
}

export const ApiActionMakePayment = (_, { data, callback } = {}) => {
  apiAxios
    .post('/wallet/payment', data)
    .then((response) => {
      if (get(response, 'data.ok')) {
        // const payload = get(response, 'data.ok')
        // dispatch('wallet/ActionAddBalance', payload)

        callback && callback(true, get(response, 'data.ok'))
      } else {
        callback && callback(false, get(response, 'data.error'))
      }
    })
    .catch((err) => {
      callback && callback(false, err)
    })
}
