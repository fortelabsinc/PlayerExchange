<template>
  <div class="login">
    <v-card-text>
      <v-form ref="form" v-model="valid" lazy-validation>
        <v-text-field
          v-model="email"
          type="text"
          name="email"
          label="Email"
          required
          :rules="rules.email"
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
      <v-spacer></v-spacer>
      <v-btn color="primary" @click="onSubmit">Sign up</v-btn>
    </v-card-actions>
  </div>
</template>

<script>
import { mapActions } from 'vuex'
export default {
  name: 'Signup',
  data() {
    return {
      valid: true,
      rules: {
        password: [(v) => v.length >= 6 || 'Min 6 characters'],
        email: [
          (v) => !!v || 'E-mail is required',
          (v) => /.+@.+\..+/.test(v) || 'E-mail must be valid',
        ],
      },
      email: '',
      password: '',
      keepLoggedIn: true,
    }
  },
  methods: {
    ...mapActions({
      register: 'auth/ApiActionRegister',
    }),
    onSubmit() {
      if (!this.$refs.form.validate()) {
        return
      }
      this.register({
        username: this.email,
        email: this.email,
        password: this.password,
      }).then((data) => {
        if (undefined != data['payload']) {
          this.$router.push({ name: 'Login' })
        } else {
          console.log('Error: ' + JSON.stringify(data))
        }
      })
    },
  },
}
</script>
