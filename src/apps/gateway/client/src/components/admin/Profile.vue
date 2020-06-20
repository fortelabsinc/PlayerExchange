<template>
  <v-row>
    <v-col>
      <AppLayoutPanel>
        <v-toolbar flat color="white">
          <v-toolbar-title>My Profile</v-toolbar-title>
        </v-toolbar>
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
      </AppLayoutPanel>
    </v-col>

    <v-col>
      <AppLayoutPanel>
        <v-toolbar flat color="white">
          <v-toolbar-title>My Balance</v-toolbar-title>
        </v-toolbar>

        <v-text-field
          v-for="item in balance"
          :key="item.id"
          v-model="item.balance"
          :name="item.id"
          :label="item.id"
          type="text"
          readonly
        />
      </AppLayoutPanel>
    </v-col>
  </v-row>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import AppLayoutPanel from '@/components/admin/AppLayoutPanel.vue'

export default {
  name: 'ProfilePage',
  components: {
    AppLayoutPanel,
  },
  computed: {
    ...mapGetters({
      username: 'auth/getUserName',
      email: 'auth/getEmail',
      pay_id: 'auth/getPayId',
      balance: 'wallet/getBalances',
    }),
  },
  mounted() {
    this.getBalances().then((error) => {
      if (error) {
        this.$toast.error('Error getting balances')
      }
    })
  },
  methods: {
    ...mapActions({
      getBalances: 'wallet/ApiActionFetchBalances',
    }),
  },
}
</script>
