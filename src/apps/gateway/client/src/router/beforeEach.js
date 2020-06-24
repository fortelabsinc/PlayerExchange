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
      next({ name: 'Home' })
    }
  } else if (isEmpty(token) && get(to, 'meta.requireAuth')) {
    next({ name: 'Login', query: { redirect: to.name, params: to.params } })
  } else {
    next()
  }
}
