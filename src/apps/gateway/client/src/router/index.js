import Vue from 'vue'
import Router from 'vue-router'
import beforeEach from './beforeEach'
import routes from './routes'

Vue.use(Router)

const router = new Router({
  mode: process.env.VUE_APP_ROUTER_MODE_HISTORY === 'true' ? 'history' : 'hash',
  routes,
})

router.beforeEach(beforeEach)

export default router
