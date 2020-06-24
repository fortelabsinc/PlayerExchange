<template>
  <v-row>
    <v-col>
      <AppLayoutPanel>
        <v-toolbar flat color="white">
          <v-toolbar-title>My Profile</v-toolbar-title>
        </v-toolbar>
        <v-row>
          <v-col>
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
          </v-col>
        </v-row>
      </AppLayoutPanel>
    </v-col>

    <v-col>
      <CurrenciesPanel />
    </v-col>
  </v-row>
</template>

<script>
import { mapGetters } from 'vuex'
import AppLayoutPanel from '@/components/admin/AppLayoutPanel.vue'
import CurrenciesPanel from '@/components/common/MyCurrenciesPanel.vue'

export default {
  name: 'ProfilePage',
  components: {
    AppLayoutPanel,
    CurrenciesPanel,
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
