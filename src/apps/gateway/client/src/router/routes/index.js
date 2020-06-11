import auth from './auth'
import admin from './admin'

export default [
  {
    path: '*',
    // redirect: { name: 'dashboard' },
    redirect: { name: 'login' },
  },
  auth,
  admin,
]
