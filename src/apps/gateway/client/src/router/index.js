import Vue from 'vue'
import Router from 'vue-router'
import AuthLayout from '../components/auth/AuthLayout'
import AppLayout from '../components/admin/AppLayout'
import store from '../store'

Vue.use(Router)

function requireAuth(to, from, next) {
  const token = store.getters.authToken
  if (undefined !== token && token !== '') {
    next()
  } else {
    next({
      path: '/login',
      query: { redirect: to.fullPath },
    })
  }
}

export default new Router({
  mode: process.env.VUE_APP_ROUTER_MODE_HISTORY === 'true' ? 'history' : 'hash',
  routes: [
    {
      path: '*',
      // UNCOMMENT  For Development Work
      redirect: { name: 'dashboard' },
      // COMMENT OUT  For Development work
      // redirect: { name: 'login' },
    },
    {
      path: '/auth',
      component: AuthLayout,
      children: [
        {
          name: 'login',
          path: 'login',
          component: () => import('../components/auth/login/Login.vue'),
        },
        {
          name: 'signup',
          path: 'signup',
          component: () => import('../components/auth/signup/Signup.vue'),
        },
        {
          name: 'recover-password',
          path: 'recover-password',
          component: () =>
            import('../components/auth/recover-password/RecoverPassword.vue'),
        },
        {
          path: '',
          redirect: { name: 'login' },
        },
      ],
    },
    {
      name: 'Admin',
      path: '/admin',
      component: AppLayout,
      children: [
        {
          name: 'dashboard',
          path: 'dashboard',
          component: () => import('../components/dashboard/Dashboard.vue'),
          default: true,
          // COMMENT OUT for Development work
          // beforeEnter: requireAuth,
        },
        {
          name: 'profile',
          path: 'profile',
          component: () => import('../components/profile/Profile.vue'),
        },
      ],
    },
  ],
})
