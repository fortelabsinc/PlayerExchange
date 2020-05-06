<template>
  <div>
    <va-card :title="$t('postings.table.mine.title')">

      <va-input
      :label="$t('postings.forms.payment.title')"
      v-model="payId"
      />
      <va-data-table
        :fields="fields"
        :data="postings"
        :loading="loading"
        hoverable
      >
        <template v-slot:pay="props">
          <va-button-group>
            <va-button small @click="payConfirm(props.rowData)">Confirm</va-button>
            <va-button small @click="payComplete(props.rowData)">Complete</va-button>
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
          Remove
          <!--
            {{ $t('dashboard.table.resolve') }}
          -->
          </va-button>
        </template>
      </va-data-table>
    </va-card>
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
import Network from '@/network'
import auth from '../../network/modules/auth';

export default {
  name: 'dashboard-my-postings-table',
  data () {
    return {
      postings: [
        //{
        //  type_req: "Group",
        //  user_id: "cjimison@forte.io",
        //  game_id: "World of Warcraft",
        //  details: "Need help to finish thing",
        //  complete_pay_amt: "100",
        //  complete_pay_type: "XRP",
        //} 
      ],
      loading: false,
      term: null,
      mode: 0,
      payId: '',
      showModal: false,
    }
  },
  computed: {
    fields () {
      return [
      {
        name: 'game_id',
        title: 'Game',//this.$t('tables.headings.name'),
        width: '20%',
      },
      {
        name: 'type_req',
        title: 'Type', //this.$t('tables.headings.payid'),
        width: '5%',
      },
      {
        name: 'details',
        title: 'Details',//'this.$t('tables.headings.status'),
        width: '50%',
        //sortField: 'status',
      },
      {
        name: 'confirm_pay_amt',
        title: 'Complete',//'this.$t('tables.headings.status'),
        width: '5%',
        //sortField: 'status',
      },
      {
        name: 'complete_pay_amt',
        title: 'Complete',//'this.$t('tables.headings.status'),
        width: '5%',
        //sortField: 'status',
      },
      {
        name: 'bonus_pay_amt',
        title: 'Complete',//'this.$t('tables.headings.status'),
        width: '5%',
        //sortField: 'status',
      },
      {
        name: 'bonus_pay_type',
        title: 'Type',//'this.$t('tables.headings.status'),
        width: '5%',
        //sortField: 'status',
      },
      {
        title: "Pay",
        name: '__slot:pay',
        dataClass: 'text-right',
      },
      {
        name: '__slot:remove',
        dataClass: 'text-right',
      }]
    }
  },
  mounted() {
    this.loadPostings();
  },
  methods: {
    payConfirm(data) {
      console.log(JSON.stringify(data));
      this.pay({
        "amt": data["confirm_pay_amt"],
        "type": data["confirm_pay_type"],
        "pay_id": this.payId
      });
    },
    payComplete(data) {
      this.pay({
        "amt": data["complete_pay_amt"],
        "type": data["complete_pay_type"],
        "pay_id": this.payId
      });
    },
    payBonus(data) {
      this.pay({
        "amt": data["bonus_pay_amt"],
        "type": data["bonus_pay_type"],
        "pay_id": this.payId
      });
    },
    pay(data) {
      this.showModal = true;
      Network.wallet.payment(data, (success, data) =>{
        console.log(JSON.stringify(data));
      });
    },
    loadPostings() {
      var self = this;
      Network.work.userPostings((success, data) => {
        if(success)
        {
          self.postings = data;
        }
        else
        {
          console.log("Failed to load the postings: " + data)
        }
      });
    },
    removePosting(data) {
      Network.work.deletePosting(data["post_id"], (success, data) =>
      {
        loadPostings();
      });
    }
  },
}
</script>

<style lang="scss">
</style>