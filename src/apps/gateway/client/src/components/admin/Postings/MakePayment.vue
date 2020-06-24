<template>
  <v-dialog v-model="content" :persistent="paying" max-width="600px">
    <v-card>
      <v-card-title v-if="label === ''"> Make a Payment</v-card-title>
      <v-card-title v-else> Make a Payment for: {{ label }} </v-card-title>
      <v-divider class="mb-2" />
      <v-card-text>
        <v-form ref="form" v-model="valid" lazy-validation>
          <v-text-field
            v-model="payId"
            type="text"
            name="payId"
            label="Pay ID"
            required
          />
          <v-row>
            <v-col>
              <v-text-field
                v-model="amount"
                type="text"
                name="amount"
                label="Amount"
                required
                :readonly="editable"
              />
            </v-col>
            <v-col>
              <v-select
                v-model="type"
                name="type"
                :items="currencies"
                label="Currency"
                required
                :readonly="editable"
              />
            </v-col>
          </v-row>
        </v-form>
      </v-card-text>
      <v-card-actions>
        <v-progress-linear
          v-if="paying"
          height="25"
          :active="true"
          :indeterminate="true"
          color="primary"
        >
          <strong class="white--text">Sending Payment</strong>
        </v-progress-linear>
        <template v-else>
          <v-spacer />
          <v-btn text @click="cancelPayment">
            Cancel
          </v-btn>
          <v-btn color="primary" text @click="confirmPayment">
            Confirm
          </v-btn>
        </template>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
import { mapActions, mapGetters } from 'vuex'

export default {
  name: 'MakePayment',
  props: ['value', 'data'],
  data() {
    return {
      content: this.value,
      payId: this.data ? this.data.payId : '',
      amount: this.data ? this.data.amount : '',
      type: this.data ? this.data.type : '',
      paying: false,
      valid: true,
      editable: false,
      label: '',
    }
  },
  computed: {
    ...mapGetters({
      currencies: 'options/getCurrencies',
    }),
  },
  watch: {
    value(val) {
      this.content = val
    },
    data(val) {
      this.payId = val ? val.payId : ''
      this.amount = val ? val.amount : ''
      this.type = val ? val.type : ''
      this.label = val ? val.typeLabel : ''
      this.editable = !!val
    },
    content(val) {
      this.$emit('input', val)
    },
  },
  methods: {
    ...mapActions({
      makePayment: 'wallet/ApiActionMakePayment',
    }),
    cancelPayment() {
      this.payId = ''
      this.amount = 0
      this.type = ''
      this.content = false
    },
    confirmPayment() {
      this.paying = true
      this.makePayment({
        pay_id: this.payId,
        amt: String(this.amount),
        type: this.type,
      }).then(({ error }) => {
        this.content = false
        this.paying = false
        this.payId = ''
        this.amount = 0
        this.type = ''
        if (!error) {
          this.$toast.success('Payment sent successfully.')
        } else {
          this.$toast.error(`Error making the payment. ${error.message}`)
        }
      })
    },
  },
}
</script>
