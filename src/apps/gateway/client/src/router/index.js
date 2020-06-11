import Vue from 'vue'
import VueRouter from 'vue-router'
import beforeEach from './beforeEach'
import routes from './routes'

Vue.use(VueRouter)

const router = new VueRouter({
  routes,
})

router.beforeEach(beforeEach)

export default router
