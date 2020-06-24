<template>
  <AppLayoutPanel>
    <v-toolbar flat color="white">
      <v-toolbar-title>Postings</v-toolbar-title>
    </v-toolbar>

    <v-data-table
      fixed-header
      loading-text="Loading..."
      :headers="headers"
      :items="postingsList"
      :loading="loading"
      :options.sync="options"
      :server-items-length="totalItems"
    >
      <template v-slot:item.game_id="{ item }">
        {{ games[item.game_id] }}
      </template>

      <template v-slot:item.confirm_pay_amt="{ item }">
        {{ `${item.confirm_pay_amt} ${item.confirm_pay_type}` }}
      </template>

      <template v-slot:item.complete_pay_amt="{ item }">
        {{ `${item.complete_pay_amt} ${item.complete_pay_type}` }}
      </template>

      <template v-slot:item.bonus_pay_amt="{ item }">
        {{ `${item.bonus_pay_amt} ${item.bonus_pay_type}` }}
      </template>
      <template v-slot:item.actions="{ item }">
        <v-btn color="primary" small dark outlined @click="showDetails(item)">
          Details
        </v-btn>
      </template>
    </v-data-table>

    <v-dialog v-model="dialog">
      <v-card>
        <v-card-title>
          Post Details
        </v-card-title>
        <v-divider class="mb-2" />
        <v-card-text>
          <PostDetails :posting="currentItem" />
        </v-card-text>
        <v-card-actions>
          <v-spacer />
          <v-btn color="primary" text @click="closeDetails">
            Close
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </AppLayoutPanel>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import AppLayoutPanel from '@/components/admin/AppLayoutPanel.vue'
import PostDetails from '@/components/admin/Postings/PostDetails.vue'

export default {
  name: 'PostingsPage',
  components: {
    AppLayoutPanel,
    PostDetails,
  },
  data() {
    return {
      // postingsList: [
      //   {
      //     type_req: 'Group',
      //     user_id: 'cjimison@forte.io',
      //     game_id: 'World of Warcraft',
      //     details: 'Need help to finish thing',
      //     complete_pay_amt: '100',
      //     complete_pay_type: 'XRP',
      //   },
      // ],
      dialog: false,
      currentItem: {},
      loading: false,
      totalItems: 0,
      options: {},
      games: {},
    }
  },
  computed: {
    ...mapGetters({
      postingsList: 'work/getAllPostings',
      postingsItemsPerPage: 'work/getPostingsItemsPerPage',
    }),
    headers() {
      return [
        {
          text: 'Game',
          align: 'start',
          value: 'game_id',
          sortable: false,
        },
        {
          text: 'Type',
          align: 'start',
          value: 'type_req',
          sortable: false,
        },
        {
          text: 'User',
          align: 'start',
          value: 'user_id',
          sortable: false,
        },
        {
          text: 'Confirm Amt',
          align: 'start',
          value: 'confirm_pay_amt',
          sortable: false,
        },
        {
          text: 'Complete Amt',
          align: 'start',
          value: 'complete_pay_amt',
          sortable: false,
        },
        {
          text: 'Bonus Amt',
          align: 'start',
          value: 'bonus_pay_amt',
          sortable: false,
        },
        { text: '', align: 'end', value: 'actions', sortable: false },
      ]
    },
  },
  watch: {
    options: {
      handler() {
        this.fetchTableData()
      },
      deep: true,
    },
  },
  mounted() {
    this.options.itemsPerPage = this.postingsItemsPerPage
    // this.fetchTableData()
  },
  methods: {
    ...mapActions({
      getPostingsPage: 'work/ApiActionFetchAllPostings',
      getAllAppNames: 'apps/ApiActionFetchAllAppNames',
    }),
    fetchTableData() {
      const { page, itemsPerPage } = this.options
      this.loading = true

      this.getAllAppNames().then(({ payload }) => {
        if (payload) {
          this.games = payload
        }
      })

      this.getPostingsPage({ page: page - 1, count: itemsPerPage }).then(
        ({ payload }) => {
          if (payload) {
            this.totalItems = payload.count
          }
          this.loading = false
        }
      )
    },
    showDetails(item) {
      this.currentItem = item
      this.dialog = true
    },
    closeDetails() {
      this.currentItem = {}
      this.dialog = false
    },
  },
}
</script>
