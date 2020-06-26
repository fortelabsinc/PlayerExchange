<template>
  <div>
    <v-tabs v-model="tab" background-color="normal">
      <v-tab>My Profile</v-tab>
      <v-tab>My Currencies</v-tab>
    </v-tabs>
    <v-tabs-items v-model="tab">
      <v-tab-item key="0">
        <AppLayoutPanel>
          <v-text-field
            v-model="username"
            name="Name"
            label="Name"
            type="text"
            readonly
          />

          <v-text-field
            v-model="email"
            name="Email"
            label="Email"
            type="text"
            readonly
          />

          <v-text-field
            v-model="pay_id"
            name="pay_id"
            label="pay_id"
            type="text"
            readonly
          />

          <v-text-field
            v-model="user_id"
            name="user_id"
            label="User ID"
            type="text"
            readonly
          />
        </AppLayoutPanel>
      </v-tab-item>

      <v-tab-item key="1">
        <MyCurrenciesPanel />
      </v-tab-item>
    </v-tabs-items>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import AppLayoutPanel from '@/components/admin/AppLayoutPanel.vue'
import MyCurrenciesPanel from './MyCurrenciesPanel.vue'

export default {
  name: 'ProfilePage',
  components: {
    AppLayoutPanel,
    MyCurrenciesPanel,
  },
  data() {
    return {
      tab: null,
    }
  },
  computed: {
    ...mapGetters({
      username: 'auth/getUserName',
      email: 'auth/getEmail',
      pay_id: 'auth/getPayId',
      user_id: 'auth/getUserId',
    }),
  },
}
</script>
