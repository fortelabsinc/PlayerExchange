import auth from './auth'
import admin from './admin'

export default [
  {
    path: '*',
    redirect: { name: 'Login' },
  },
  auth,
  admin,
]
