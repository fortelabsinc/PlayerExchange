<template>
  <div>
    <va-card :title="$t('postings.table.mine.title')">
      <va-input v-model="payId" :label="$t('postings.forms.payment.title')" />
      <va-data-table
        :fields="fields"
        :data="postings"
        :loading="loading"
        hoverable
      >
        <template v-slot:pay="props">
          <va-button-group>
            <va-button small @click="payConfirm(props.rowData)">
              {{ $t('postings.table.mine.confirm_bt') }}
            </va-button>
            <va-button small @click="payComplete(props.rowData)">
              {{ $t('postings.table.mine.complete_bt') }}
            </va-button>
            <va-button small @click="payBonus(props.rowData)">Bonus</va-button>
          </va-button-group>
        </template>
        <template v-slot:remove="props">
          <va-button
            small
            outline
            color="danger"
            class="ma-0"
            @click="removePosting(props.rowData)"
          >
            {{ $t('postings.table.mine.remove_bt') }}
          </va-button>
        </template>
      </va-data-table>
    </va-card>
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
  name: 'DashboardMyPostingsTable',
  data() {
    return {
      // postings: [
      //   {
      //     type_req: 'Group',
      //     user_id: 'cjimison@forte.io',
      //     game_id: 'World of Warcraft',
      //     details: 'Need help to finish thing',
      //     complete_pay_amt: '100',
      //     complete_pay_type: 'XRP',
      //   },
      // ],
      loading: false,
      payId: '',
      showModal: false,
    }
  },
  computed: {
    ...mapGetters({
      postings: 'work/getMyPostings',
    }),
    fields() {
      return [
        {
          name: 'game_id',
          title: this.$t('postings.table.mine.fields.game_id'),
          width: '20%',
        },
        {
          name: 'type_req',
          title: this.$t('postings.table.mine.fields.type_req'),
          width: '5%',
        },
        {
          name: 'details',
          title: this.$t('postings.table.mine.fields.details'),
          width: '50%',
        },
        {
          name: 'confirm_pay_amt',
          title: this.$t('postings.table.mine.fields.confirm_pay_amt'),
          width: '5%',
        },
        {
          name: 'complete_pay_amt',
          title: this.$t('postings.table.mine.fields.complete_pay_amt'),
          width: '5%',
        },
        {
          name: 'bonus_pay_amt',
          title: this.$t('postings.table.mine.fields.bonus_pay_amt'),
          width: '5%',
        },
        {
          name: 'bonus_pay_type',
          title: this.$t('postings.table.mine.fields.bonus_pay_type'),
          width: '5%',
        },
        {
          title: 'Pay',
          name: '__slot:pay',
          dataClass: 'text-right',
        },
        {
          name: '__slot:remove',
          dataClass: 'text-right',
        },
      ]
    },
  },
  mounted() {
    this.loading = true
    this.loadMyPostings({
      callback: (success) => {
        this.loading = false
        if (!success) {
          console.log('Failed to load the postings')
        }
      },
    })
  },
  methods: {
    ...mapActions({
      loadMyPostings: 'work/ApiActionFetchMyUserPostings',
      deletePostings: 'work/ApiActionDeletePosting',
      makePayment: 'wallet/ApiActionMakePayment',
    }),
    payConfirm(data) {
      this.pay({
        amt: data['confirm_pay_amt'],
        type: data['confirm_pay_type'],
        pay_id: this.payId,
      })
    },
    payComplete(data) {
      this.pay({
        amt: data['complete_pay_amt'],
        type: data['complete_pay_type'],
        pay_id: this.payId,
      })
    },
    payBonus(data) {
      this.pay({
        amt: data['bonus_pay_amt'],
        type: data['bonus_pay_type'],
        pay_id: this.payId,
      })
    },
    pay(data) {
      this.showModal = true
      this.makePayment({
        data,
        callback: (success) => {
          if (success) {
            console.log('Payment success')
          } else {
            console.log('Failed to load the postings')
          }
        },
      })
    },
    removePosting(data) {
      this.deletePosting({
        postingId: data['post_id'],
        callback: (success) => {
          if (success) {
            console.log('Posting delete success')
          }
        },
      })
    },
  },
}
</script>

<style lang="scss"></style>
