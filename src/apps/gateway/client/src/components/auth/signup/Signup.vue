<template>
  <form @submit.prevent="onsubmit()">
    <va-input
      v-model="email"
      type="email"
      :label="$t('auth.email')"
      :error="!!emailErrors.length"
      :error-messages="emailErrors"
    />

    <va-input
      v-model="password"
      type="password"
      :label="$t('auth.password')"
      :error="!!passwordErrors.length"
      :error-messages="passwordErrors"
    />

    <div class="auth-layout__options d-flex align--center justify--space-between">
      <va-checkbox
        v-model="agreedToTerms"
        class="mb-0"
        :error="!!agreedToTermsErrors.length"
        :errorMessages="agreedToTermsErrors"
      >
        <template slot="label">
          {{ $t('auth.agree') }}
          <span class="link">{{ $t('auth.termsOfUse') }}</span>
        </template>
      </va-checkbox>
      <router-link class="ml-1 link" :to="{name: 'recover-password'}">
        {{$t('auth.recover_password')}}
      </router-link>
    </div>

    <div class="d-flex justify--center mt-3">
      <va-button type="submit" class="my-0">{{ $t('auth.sign_up') }}</va-button>
    </div>
  </form>
</template>

<script>
import Network from '../../../network'
export default {
  name: 'signup',
  data () {
    return {
      email: '',
      password: '',
      agreedToTerms: false,
      emailErrors: [],
      passwordErrors: [],
      agreedToTermsErrors: [],
    }
  },
  methods: {
    onsubmit () {

      var self = this;
      this.emailErrors = this.email ? [] : ['Email is required']
      this.passwordErrors = this.password ? [] : ['Password is required']
      if (!this.formReady) {
        return
      }
      Network.auth.register(this.email, this.email, this.password, (success, rsp) => {
        if(success){
          self.$router.push({ name: 'login' });
        }
        else{
          console.log("Failed to log in user: " + JSON.stringify(rsp));
          self.emailErrors = ['Login Failed'];
          self.passwordErrors = ['Login Failed'];
        }
      });
    },
  },
  computed: {
    formReady () {
      return !(this.emailErrors.length || this.passwordErrors.length || this.agreedToTermsErrors.length)
    },
  },
}
</script>

<style lang="scss">
</style>
