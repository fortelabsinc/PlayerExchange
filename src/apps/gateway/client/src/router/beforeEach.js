import store from '../store'
import { isEmpty, get } from 'lodash'

export default (to, from, next) => {
  // const skipAuth = true
  // if (skipAuth) {
  //   next()
  //   return
  // }

  const token = store.getters['auth/getToken']
  if (to.name === 'login') {
    if (isEmpty(token)) {
      next()
    } else {
      next({ path: '/dashboard' })
    }
  } else if (isEmpty(token) && get(to, 'meta.requireAuth')) {
    next({ path: '/login', query: { redirect: to.fullPath } })
  } else {
    next()
  }
}
