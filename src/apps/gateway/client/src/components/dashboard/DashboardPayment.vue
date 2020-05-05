<template>
  <div class="row row-equal">
    <div class="flex xs12">
      <va-card :title="$t('postings.forms.payment.title')">
        <form>
          <div class="row">
            <div class="flex xs4">
              <va-input
                :label="$t('postings.forms.payment.payid')"
                v-model="payId"
                textBy="description"
              />
            </div>
            <div class="flex xs4">
              <va-input
                :label="$t('postings.forms.payment.amount')"
                v-model="amt"
                textBy="The number of player needed"
              />
            </div>
            <div class="flex xs4">
              <va-select
                :label="$t('postings.forms.payment.type')"
                v-model="type"
                textBy="Type of Players"
                :options="currencies"
              />
            </div>
            <div class="flex xs4">
              <va-button @click="submit">
                {{$t('postings.forms.payment.button_submit') }}
              </va-button> 
            </div>
          </div>
        </form>
      </va-card>
    </div>
    <va-modal
      v-model="showModal"
      size="small"
      :title=" $t('postings.forms.payment.submit_title')"
      cancelClass="none"
      :message=" $t('postings.forms.payment.submit_message') "
      :okText=" $t('postings.forms.payment.submit_confirm') "
      noOutsideDismiss
      noEscDismiss
    />
  </div>
</template>

<script>
import store from '@/store';
import Network from '../../network'

export default {
  name: 'dashboard-payment',
  data () {
    return {
      payId: '',
      amt: '1',
      type: 'XRP',
      showModal: false,
      currencies: [],
    }
  },
  mounted() {
    this.currencies = store.getters.currencies;
  },
  watch: {
  },
  methods: {
    submit(event){
      var self = this;
      this.showModal = true;
      var data = {
          pay_id: this.payId,
          amt: String(this.amt),
          type: this.type
      };
      Network.work.payment(data, (success, data) => {
        if(success)
        {
          self.payId = '';
          self.amt = '1';
          self.type = 'XRP';
        }
        else
        {

        }
      });
    }
  },
  computed: {
  },
}
</script>

<style scoped>
  .chart {
    height: 400px;
  }
</style>
