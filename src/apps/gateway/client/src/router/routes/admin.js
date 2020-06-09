import AppLayout from '@/components/admin/AppLayout'

export default {
  name: 'Admin',
  path: '/admin',
  component: AppLayout,
  children: [
    {
      name: 'Home',
      path: '/home',
      component: () =>
        import(/* webpackChunkName: "home" */ '@/components/admin/Home.vue'),
      default: true,
      meta: {
        requireAuth: true,
      },
    },
    {
      name: 'Postings',
      path: '/postings',
      component: () =>
        import(
          /* webpackChunkName: "postingsPage" */ '@/components/admin/Postings/PostingsPage.vue'
        ),
      meta: {
        requireAuth: true,
      },
    },
    // {
    //   name: 'Posting',
    //   path: '/postings/id/:id',
    //   component: () =>
    //     import(
    //       /* webpackChunkName: "postingPage" */ '@/components/admin/Postings/PostingPage.vue'
    //     ),
    //   meta: {
    //     requireAuth: true,
    //   },
    // },
    // {
    //   name: 'NewPosting',
    //   path: '/postings/new',
    //   component: () =>
    //     import(
    //       /* webpackChunkName: "newPostingPage" */ '@/components/admin/Postings/NewPostingPage.vue'
    //     ),
    //   meta: {
    //     requireAuth: true,
    //   },
    // },
    {
      name: 'Profile',
      path: '/profile',
      component: () =>
        import(
          /* webpackChunkName: "profile" */ '@/components/admin/Profile.vue'
        ),
      meta: {
        requireAuth: true,
      },
    },
  ],
}
