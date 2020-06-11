import state from './state'
import mutations from './mutations'
import * as actions from './actions'
import * as apiActions from './actions.api'
import * as getters from './getters'

export default {
  state,
  actions: { ...actions, ...apiActions },
  getters,
  mutations,
  namespaced: true,
}
