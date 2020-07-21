<template>
  <AppLayoutPanel>
    <div class="d-flex">
      <v-btn color="success" @click="dialogPayment = true">
        Make a Payment
      </v-btn>
      <MakePayment v-model="dialogPayment" />
      <v-spacer />

      <v-btn icon @click="getTheBalances()">
        <v-icon large>
          mdi-refresh
        </v-icon>
      </v-btn>
    </div>
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
  name: 'MyCurrenciesPanel',
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
      balance: 'wallet/getBalances',
    }),
  },
  mounted() {
    this.getTheBalances()
  },
  methods: {
    ...mapActions({
      getBalances: 'wallet/ApiActionFetchBalances',
    }),
    getTheBalances() {
      this.getBalances().then(({ error }) => {
        if (error) {
          this.$toast.error(
            'Error getting balances: ' + JSON.stringify(error.message)
          )
        } else {
          this.$toast.success('Info updated')
        }
      })
    },
  },
}
</script>
