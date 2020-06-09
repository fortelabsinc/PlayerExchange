import apiAxios from '../../apiAxios'
import { apiResponseHandler, apiErrorHandler } from '../../utils/api'
import { BALANCE_LIST_SET, BALANCE_LIST_ADD } from './mutations'

export const ApiActionFetchBalances = ({ commit }) =>
  apiAxios
    .get('/wallet/balance')
    .then((response) =>
      apiResponseHandler(response).then(({ payload }) => {
        commit(BALANCE_LIST_SET, payload)
        return { payload }
      })
    )
    .catch(apiErrorHandler)

export const ApiActionMakePayment = ({ commit }, { data }) =>
  apiAxios
    .post('/wallet/payment', data)
    .then((response) =>
      apiResponseHandler(response).then(({ payload }) => {
        commit(BALANCE_LIST_ADD, payload)
        return { payload }
      })
    )
    .catch(apiErrorHandler)
