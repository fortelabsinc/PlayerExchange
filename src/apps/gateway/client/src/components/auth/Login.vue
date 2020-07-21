<template>
  <div class="my-container">
    <VueElementLoading
      :active="isActive"
      spinner="bar-fade-scale"
      color="#1976d2"
    />
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
  </div>
</template>

<script>
import { mapActions } from 'vuex'
import VueElementLoading from 'vue-element-loading'
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
      isActive: false,
    }
  },
  mounted() {
    const self = this
    this.checkAuth().then(({ payload, error }) => {
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
      if (error) {
        this.$toast.error(`Error checking auth. ${error.message}`)
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

      this.isActive = true

      this.login({
        username: this.username,
        password: this.password,
      }).then(({ error, payload, ...data }) => {
        this.isActive = false
        if (payload) {
          this.$router.push({ name: 'Home' })
          this.$toast.success('Successfuly logged in')
        } else {
          this.$router.push({ name: 'Home' })
          this.$toast.error(`Error logging in, no payload.`)
          console.log('Error: ' + JSON.stringify(data))
        }
        if (error) {
          this.$toast.error(`Error logging in. ${error.message}`)
        }
      })
    },
  },
  components: {
    VueElementLoading,
  },
}
</script>
