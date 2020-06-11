import AuthLayout from '../../components/auth/AuthLayout'

export default {
  path: '/auth',
  component: AuthLayout,
  children: [
    {
      name: 'login',
      path: '/login',
      component: () => import('../../components/auth/login/Login.vue'),
    },
    {
      name: 'signup',
      path: '/signup',
      component: () => import('../../components/auth/signup/Signup.vue'),
    },
    {
      name: 'recover-password',
      path: 'recover-password',
      component: () =>
        import('../../components/auth/recover-password/RecoverPassword.vue'),
    },
    {
      path: '',
      redirect: { name: 'login' },
    },
  ],
}
