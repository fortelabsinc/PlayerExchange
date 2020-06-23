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
      <AppLayoutPanel>
        <v-toolbar flat color="white">
          <v-toolbar-title>My Currencies</v-toolbar-title>

          <v-spacer></v-spacer>
          <v-btn icon>
            <v-icon large class="mr-4" @click="getTheBalances()">
              mdi-refresh
            </v-icon>
          </v-btn>
        </v-toolbar>
        <v-row>
          <v-col>
            <v-text-field
              v-for="item in balance"
              :key="item.id"
              v-model="item.balance"
              :name="item.id"
              :label="item.id"
              type="text"
              readonly
            />
          </v-col>
          <v-col>
            <v-text-field
              v-for="item in balance"
              :key="item.id"
              v-model="item.address"
              type="text"
              readonly
            />
          </v-col>
        </v-row>
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
      user_id: 'auth/getUserId',
      balance: 'wallet/getBalances',
    }),
  },
  mounted() {
    this.getBalances().then((rsp) => {
      if (undefined != rsp.error) {
        this.$toast.error(
          'Error getting balances: ' + JSON.stringify(rsp.error.message)
        )
      }
    })
  },
  methods: {
    ...mapActions({
      getBalances: 'wallet/ApiActionFetchBalances',
    }),
    getTheBalances: function() {
      this.getBalances().then((rsp) => {
        if (undefined != rsp.error) {
          this.$toast.error(
            'Error getting balances: ' + JSON.stringify(rsp.error.message)
          )
        } else {
          this.$toast.success('Info updated')
        }
      })
    },
  },
}
</script>
