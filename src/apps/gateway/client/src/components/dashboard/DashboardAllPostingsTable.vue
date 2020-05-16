<template>
  <va-card :title="$t('postings.table.all.title')">
    <va-data-table
      :fields="fields"
      :data="postings"
      :loading="loading"
      hoverable
    >
      <template v-slot:actions="props">
        <va-button
          small
          outline
          color="success"
          class="ma-0"
          @click="showDetailsModal(props.rowData)"
        >
          {{ $t('postings.table.all.details_bt') }}
        </va-button>

        <va-modal
          v-model="isModalVisible"
          size="large"
          position="top"
          hide-default-actions
          :title="$t('postingDetails.modal.title')"
          class="flex"
        >
          <dashboard-posting-details :posting="selectedPosting" />
          <div class="mt-3 mb-3 va-modal__actions">
            <va-button flat color="gray" @click="isModalVisible = false">
              {{ $t('postingDetails.modal.close') }}
            </va-button>
          </div>
        </va-modal>
      </template>
    </va-data-table>
  </va-card>
</template>

<script>
import DashboardPostingDetails from './DashboardPostingDetails'
import { mapGetters, mapActions } from 'vuex'

export default {
  name: 'DashboardAllPostingsTable',
  components: {
    DashboardPostingDetails,
  },
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
      isModalVisible: false,
      selectedPosting: {},
    }
  },
  computed: {
    ...mapGetters({
      postings: 'work/getAllPostings',
    }),
    fields() {
      return [
        {
          name: 'game_id',
          title: this.$t('postings.table.all.fields.game_id'),
          width: '20%',
        },
        {
          name: 'type_req',
          title: this.$t('postings.table.all.fields.type_req'),
          width: '5%',
        },
        {
          name: 'user_id',
          title: this.$t('postings.table.all.fields.user_id'),
          width: '10%',
        },
        {
          name: 'details',
          title: this.$t('postings.table.all.fields.details'),
          width: '40%',
        },
        {
          name: 'complete_pay_amt',
          title: this.$t('postings.table.all.fields.complete_pay_amt'),
          width: '10%',
        },
        {
          name: 'complete_pay_type',
          title: this.$t('postings.table.all.fields.complete_pay_type'),
          width: '10%',
        },
        {
          name: '__slot:actions',
          dataClass: 'text-right',
        },
      ]
    },
  },
  mounted() {
    this.loading = true
    this.loadPostings({
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
      loadPostings: 'work/ApiActionFetchAllPostings',
    }),
    showDetailsModal(data) {
      this.selectedPosting = data
      this.isModalVisible = true
    },
  },
}
</script>
