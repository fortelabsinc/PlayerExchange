<template>
  <div class="row row-equal">
    <div class="flex xs12">
      <va-card :title="$t('postings.forms.payment.title')">
        <form>
          <div class="row">
            <div class="flex xs4">
              <va-input
                v-model="payId"
                :label="$t('postings.forms.payment.payid')"
                text-by="description"
              />
            </div>
            <div class="flex xs4">
              <va-input
                v-model="amt"
                :label="$t('postings.forms.payment.amount')"
                text-by="The number of player needed"
              />
            </div>
            <div class="flex xs4">
              <va-select
                v-model="type"
                :label="$t('postings.forms.payment.type')"
                text-by="Type of Players"
                :options="currencies"
              />
            </div>
            <div class="flex xs4">
              <va-button @click="submit">
                {{ $t('postings.forms.payment.button_submit') }}
              </va-button>
            </div>
          </div>
        </form>
      </va-card>
    </div>
    <va-modal
      v-model="showModal"
      size="small"
      :title="$t('postings.forms.payment.submit_title')"
      cancel-class="none"
      :message="$t('postings.forms.payment.submit_message')"
      :ok-text="$t('postings.forms.payment.submit_confirm')"
      no-outside-dismiss
      no-esc-dismiss
    />
  </div>
</template>

<script>
import store from '@/store'
import Network from '../../network'

export default {
  name: 'DashboardPayment',
  data() {
    return {
      payId: '',
      amt: '1',
      type: 'XRP',
      showModal: false,
      currencies: [],
    }
  },
  computed: {},
  watch: {},
  mounted() {
    this.currencies = store.getters.currencies
  },
  methods: {
    submit() {
      var self = this
      this.showModal = true
      var data = {
        pay_id: this.payId,
        amt: String(this.amt),
        type: this.type,
      }
      Network.wallet.payment(data, (success) => {
        if (success) {
          self.payId = ''
          self.amt = '1'
          self.type = 'XRP'
        }
      })
    },
  },
}
</script>

<style scoped>
.chart {
  height: 400px;
}
</style>
