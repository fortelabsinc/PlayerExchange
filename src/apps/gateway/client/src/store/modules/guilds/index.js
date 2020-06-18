import state from './state'
import mutations from './mutations'
import * as apiActions from './actions.api'
import * as getters from './getters'

export default {
  state,
  actions: apiActions,
  getters,
  mutations,
  namespaced: true,
}
