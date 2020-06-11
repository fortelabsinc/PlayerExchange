import Vue from 'vue'
import Vuetify, { VSnackbar, VBtn, VIcon } from 'vuetify/lib'
import VuetifyToast from 'vuetify-toast-snackbar'

Vue.use(Vuetify, {
  components: {
    VSnackbar,
    VBtn,
    VIcon,
  },
})

Vue.use(VuetifyToast, {
  showClose: true,
  closeIcon: 'mdi-close',
  queueable: true,
  shorts: {
    info: {
      icon: 'mdi-information',
      color: 'info',
    },
    success: {
      icon: 'mdi-check-circle',
      color: 'success',
    },
    error: {
      icon: 'mdi-alert',
      color: 'error',
    },
  },
})

export default new Vuetify({})
