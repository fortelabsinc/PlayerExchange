import AppLayout from '../../components/admin/AppLayout'

export default {
  name: 'Admin',
  path: '/admin',
  component: AppLayout,
  children: [
    {
      name: 'dashboard',
      path: '/dashboard',
      component: () => import('../../components/dashboard/Dashboard.vue'),
      default: true,
      meta: {
        requireAuth: true,
      },
    },
    {
      name: 'profile',
      path: '/profile',
      component: () => import('../../components/profile/Profile.vue'),
      meta: {
        requireAuth: true,
      },
    },
  ],
}
