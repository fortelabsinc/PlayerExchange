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
        import(
          /* webpackChunkName: "home" */ '@/components/admin/Home/Home.vue'
        ),
      default: true,
      meta: {
        requireAuth: true,
      },
    },
    {
      name: 'My Postings',
      path: '/my-postings',
      component: () =>
        import(
          /* webpackChunkName: "my-postingsPage" */ '@/components/admin/Postings/MyPostingsPage.vue'
        ),
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
    {
      name: 'NewPosting',
      path: '/postings/new',
      component: () =>
        import(
          /* webpackChunkName: "newPostingPage" */ '@/components/admin/Postings/NewPostPage.vue'
        ),
      meta: {
        requireAuth: true,
      },
    },
    {
      name: 'Profile',
      path: '/profile',
      component: () =>
        import(
          /* webpackChunkName: "profile" */ '@/components/admin/Profile/Profile.vue'
        ),
      meta: {
        requireAuth: true,
      },
    },
    {
      name: 'Apps',
      path: '/apps',
      component: () =>
        import(
          /* webpackChunkName: "appsPage" */ '@/components/admin/Apps/AppsPage.vue'
        ),
      meta: {
        requireAuth: true,
      },
    },
    {
      name: 'App',
      path: '/apps/id/:id',
      component: () =>
        import(
          /* webpackChunkName: "appPage" */ '@/components/admin/Apps/AppPage.vue'
        ),
      meta: {
        requireAuth: true,
      },
    },
    {
      name: 'NewApp',
      path: '/apps/new',
      component: () =>
        import(
          /* webpackChunkName: "newAppPage" */ '@/components/admin/Apps/NewAppPage.vue'
        ),
      meta: {
        requireAuth: true,
      },
    },

    {
      name: 'Guilds',
      path: '/guilds',
      component: () =>
        import(
          /* webpackChunkName: "guildsPage" */ '@/components/admin/Guilds/GuildsPage.vue'
        ),
      meta: {
        requireAuth: true,
      },
    },
    {
      name: 'Guild',
      path: '/guilds/id/:id',
      component: () =>
        import(
          /* webpackChunkName: "guildPage" */ '@/components/admin/Guilds/GuildPage.vue'
        ),
      meta: {
        requireAuth: true,
      },
    },
    {
      name: 'NewGuild',
      path: '/guilds/new',
      component: () =>
        import(
          /* webpackChunkName: "newGuildPage" */ '@/components/admin/Guilds/NewGuildPage.vue'
        ),
      meta: {
        requireAuth: true,
      },
    },
  ],
}
