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
    onSubmit() {
      if (!this.$refs.form.validate()) {
        return
      }
      // TODO: Make API call to /login
      // if (success) {
      this.$router.push({ name: 'Home' })
      // } else {
      //   console.log('Failed to log in user: ' + JSON.stringify(rsp))
      // }
    },
  },
}
</script>
