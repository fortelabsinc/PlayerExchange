<template>
  <v-app>
    <v-app-bar app clipped-left dark dense>
      <v-app-bar-nav-icon @click.stop="mini = !mini">
        <v-icon v-if="!mini" slot="default">mdi-menu-open</v-icon>
      </v-app-bar-nav-icon>

      <v-toolbar-title>Player Exchange</v-toolbar-title>

      <v-spacer />

      <v-btn icon>
        <v-icon>mdi-magnify</v-icon>
      </v-btn>
      <v-btn icon>
        <v-icon>mdi-dots-vertical</v-icon>
      </v-btn>
    </v-app-bar>

    <v-navigation-drawer :mini-variant="mini" permanent clipped app>
      <v-list dense>
        <v-list-item-group v-model="selected">
          <v-list-item v-for="item in items" :key="item.title" link>
            <v-list-item-icon>
              <v-icon>{{ item.icon }}</v-icon>
            </v-list-item-icon>

            <v-list-item-content>
              <v-list-item-title>{{ item.title }}</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
        </v-list-item-group>
      </v-list>
    </v-navigation-drawer>

    <AppLayoutContent>
      <router-view />
    </AppLayoutContent>
  </v-app>
</template>

<script>
import { findIndex } from 'lodash'
import AppLayoutContent from '@/components/admin/AppLayoutContent.vue'

export default {
  name: 'AppLayout',
  components: {
    AppLayoutContent,
  },
  data: () => ({
    mini: false,
    items: [
      { title: 'Home', icon: 'mdi-home', routeName: 'Home' },
      {
        title: 'My Postings',
        icon: 'mdi-account-box',
        routeName: 'My Postings',
      },
      {
        title: 'Postings',
        icon: 'mdi-sword',
        routeName: 'Postings',
      },
      {
        title: 'Games',
        icon: 'mdi-google-controller',
        routeName: 'Apps',
      },
      {
        title: 'Guilds',
        icon: 'mdi-sword-cross',
        routeName: 'Guilds',
      },
      { title: 'My Account', icon: 'mdi-account', routeName: 'Profile' },
    ],
  }),
  computed: {
    selected: {
      set(selected) {
        const { routeName } = this.items[selected] || {}
        if (routeName && this.$route.name !== routeName) {
          this.$router.push({ name: routeName })
        }
      },
      get() {
        return findIndex(
          this.items,
          ({ routeName }) => this.$route.name === routeName
        )
      },
    },
  },
}
</script>
