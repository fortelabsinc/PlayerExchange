import AuthLayout from '@/components/auth/AuthLayout'

export default {
  path: '/auth',
  component: AuthLayout,
  children: [
    {
      default: true,
      name: 'Login',
      path: '/login',
      component: () =>
        import(/* webpackChunkName: "login" */ '@/components/auth/Login.vue'),
    },
    {
      name: 'Signup',
      path: '/signup',
      component: () =>
        import(/* webpackChunkName: "signup" */ '@/components/auth/Signup.vue'),
    },
    {
      path: '',
      redirect: { name: 'Login' },
    },
  ],
}
