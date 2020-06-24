<template>
  <div class="login">
    <v-card-text>
      <v-form ref="form" v-model="valid" lazy-validation>
        <v-text-field
          v-model="username"
          type="text"
          name="username"
          label="Username"
          required
          :rules="rules.username"
        />
        <v-text-field
          id="password"
          v-model="password"
          label="Password"
          name="password"
          type="password"
          required
          :rules="rules.password"
        />
      </v-form>
    </v-card-text>
    <v-card-actions>
      <v-checkbox v-model="keepLoggedIn" label="Keep me logged in" />
      <v-spacer></v-spacer>
      <v-btn color="primary" @click="onSubmit">Login</v-btn>
    </v-card-actions>
  </div>
</template>

<script>
import { mapActions } from 'vuex'
export default {
  name: 'Login',
  data() {
    return {
      valid: true,
      rules: {
        password: [(v) => v.length >= 6 || 'Min 6 characters'],
        username: [(v) => !!v || 'Username is required'],
      },
      username: '',
      password: '',
      keepLoggedIn: true,
    }
  },
  mounted() {
    const self = this
    this.checkAuth().then(({ payload }) => {
      if (payload) {
        if (self.$route.query && self.$route.query.redirect) {
          self.$router.push({
            name: self.$route.query.redirect,
            params: self.$route.query.params,
          })
        } else {
          self.$router.push({ name: 'Home' })
        }
      }
    })
  },
  methods: {
    ...mapActions({
      login: 'auth/ApiActionLogin',
      checkAuth: 'auth/ApiActionCheckAuth',
    }),
    onSubmit() {
      if (!this.$refs.form.validate()) {
        return
      }

      this.login({
        username: this.username,
        password: this.password,
      }).then((data) => {
        console.log('data', data)
        if (undefined != data['payload']) {
          this.$router.push({ name: 'Home' })
        } else {
          console.log('Error: ' + JSON.stringify(data))
        }
      })
    },
  },
}
</script>
