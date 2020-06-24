<template>
  <AppLayoutPanel>
    <v-toolbar flat color="white">
      <v-toolbar-title>Guild Currencies</v-toolbar-title>
      <v-btn icon class="ml-2" @click="getTheBalances()">
        <v-icon large>
          mdi-refresh
        </v-icon>
      </v-btn>

      <v-spacer />

      <v-btn color="success" @click="dialogPayment = true">
        Make a Payment
      </v-btn>
      <MakePayment v-model="dialogPayment" />
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
import MakePayment from '@/components/common/MakePayment.vue'

export default {
  name: 'GuildCurrenciesPanel',
  props: ['guildId'],
  data() {
    return {
      dialogPayment: false,
    }
  },
  components: {
    AppLayoutPanel,
    MakePayment,
  },
  computed: {
    ...mapGetters({
      balance: 'guilds/getBalances',
    }),
  },
  mounted() {
    this.getTheBalances()
  },
  methods: {
    ...mapActions({
      getBalances: 'guilds/ApiActionBalanceGuild',
    }),
    getTheBalances() {
      this.getBalances({ guild_id: this.guildId }).then((rsp) => {
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
