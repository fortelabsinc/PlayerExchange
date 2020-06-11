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
import { mapGetters, mapActions } from 'vuex'

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
  computed: {
    ...mapGetters({
      currencies: 'options/getCurrencies',
    }),
  },
  methods: {
    ...mapActions({
      makePayment: 'wallet/ApiActionMakePayment',
    }),
    submit() {
      this.showModal = true
      var data = {
        pay_id: this.payId,
        amt: String(this.amt),
        type: this.type,
      }
      this.makePayment({
        data,
        callback: (success) => {
          if (success) {
            console.log('Payment success')
          } else {
            console.log('Failed to make a payment')
          }
        },
      })
    },
  },
}
</script>
