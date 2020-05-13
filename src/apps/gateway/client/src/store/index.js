import Vue from 'vue'
import Vuex from 'vuex'
import VuexI18n from 'vuex-i18n'
import modules from './modules'

// TODO: Remove this old getters
import * as getters from './getters'

Vue.use(Vuex)

const store = new Vuex.Store({
  strict: process.env.NODE_ENV !== 'production',
  getters,
  modules,
})

Vue.use(VuexI18n.plugin, store)

export default store
