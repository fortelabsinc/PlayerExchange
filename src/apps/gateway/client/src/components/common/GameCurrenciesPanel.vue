<template>
  <AppLayoutPanel>
    <v-toolbar flat color="white">
      <v-toolbar-title>Game Currencies</v-toolbar-title>

      <v-spacer></v-spacer>
      <v-btn icon class="m-4" @click="getTheBalances()">
        <v-icon large>
          mdi-refresh
        </v-icon>
      </v-btn>
    </v-toolbar>
    <v-row>
      <v-col lg="4">
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
      <v-col lg="8">
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
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import AppLayoutPanel from '@/components/admin/AppLayoutPanel.vue'

export default {
  name: 'GameCurrenciesPanel',
  props: ['gameId'],
  components: {
    AppLayoutPanel,
  },
  computed: {
    ...mapGetters({
      balance: 'apps/getBalances',
    }),
  },
  mounted() {
    this.getTheBalances()
  },
  methods: {
    ...mapActions({
      getBalances: 'apps/ApiActionBalanceApp',
    }),
    getTheBalances() {
      this.getBalances({ game_id: this.gameId }).then((rsp) => {
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
