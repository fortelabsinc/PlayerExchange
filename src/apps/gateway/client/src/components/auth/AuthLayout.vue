<template>
  <v-app class="auth-layout">
    <v-content class="grey lighten-3 flex-sm-grow-1 align-sm-center">
      <v-row class="mb-6" :align="'end'" :justify="'center'">
        <router-link class="logo text-primary" to="/">
          Player Exchange
        </router-link>
      </v-row>

      <v-row :align="'start'" :justify="'center'">
        <v-card class="card">
          <v-toolbar flat>
            <v-tabs v-model="tabIndex" centered>
              <v-tab
                v-for="item in tabs"
                :key="item.routeName"
                :href="'#' + item.routeName"
              >
                {{ item.title }}
              </v-tab>
            </v-tabs>
          </v-toolbar>
          <router-view />
        </v-card>
      </v-row>
    </v-content>
  </v-app>
</template>

<script>
export default {
  name: 'AuthLayout',
  data: () => ({
    tabs: [
      { routeName: 'Login', title: 'Login' },
      { routeName: 'Signup', title: 'Create Account' },
    ],
  }),
  computed: {
    tabIndex: {
      set(tabIndex) {
        if (this.$route.name !== tabIndex) {
          this.$router.push({ name: tabIndex })
        }
      },
      get() {
        return this.$route.name
      },
    },
  },
}
</script>

<style lang="scss">
.auth-layout {
  .logo {
    font-size: 36px;
    font-weight: bold;
    text-decoration: none;
  }

  .card {
    width: 100%;
    max-width: 600px;
  }
}
</style>
