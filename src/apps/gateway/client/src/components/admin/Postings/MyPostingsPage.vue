<template>
  <AppLayoutPanel>
    <v-toolbar flat color="white">
      <v-toolbar-title>My Postings</v-toolbar-title>
      <v-spacer />
      <v-btn color="success" class="mb-2 mr-2" @click="dialogPayment = true">
        Make a Payment
      </v-btn>
      <v-btn color="primary" class="mb-2" @click="newItem()">New Post</v-btn>
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
      <template v-slot:item.order_id="{ item }">
        <router-link :to="`/postings/id/${item.posting_id}`">
          {{ item.posting_id }}
        </router-link>
      </template>

      <template v-slot:item.actions="{ item }">
        <v-btn color="primary" text @click="payItem(item)">
          pay
        </v-btn>
        <v-icon small color="red" @click="deleteItem(item)">
          mdi-delete
        </v-icon>
      </template>
    </v-data-table>

    <v-dialog v-model="dialog" :persistent="deleting" max-width="600px">
      <v-card>
        <v-card-title>
          Are you sure you want to delete this posting?
        </v-card-title>
        <v-divider class="mb-2" />
        <v-card-text>
          <p>Post ID: {{ currentItem.posting_id }}</p>
          <p>Name: {{ currentItem.postingName }}</p>
        </v-card-text>
        <v-card-actions>
          <v-progress-linear
            v-if="deleting"
            height="25"
            :active="true"
            :indeterminate="true"
            color="primary"
          >
            <strong class="white--text">Deleting</strong>
          </v-progress-linear>
          <template v-else>
            <v-spacer />
            <v-btn text @click="cancelDelete">
              Cancel
            </v-btn>
            <v-btn color="primary" text @click="confirmDelete">
              Confirm
            </v-btn>
          </template>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <MakePayment v-model="dialogPayment" />
  </AppLayoutPanel>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import AppLayoutPanel from '@/components/admin/AppLayoutPanel.vue'
import MakePayment from './MakePayment.vue'

export default {
  name: 'MyPostingsPage',
  components: {
    AppLayoutPanel,
    MakePayment,
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
      dialogPayment: false,
      currentItem: {},
      loading: false,
      deleting: false,
      totalItems: 0,
      options: {},
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
          text: 'game_id',
          align: 'start',
          value: 'game_id',
          sortable: false,
        },
        {
          text: 'type_req',
          align: 'start',
          value: 'type_req',
          sortable: false,
        },
        {
          text: 'user_id',
          align: 'start',
          value: 'user_id',
          sortable: false,
        },
        {
          text: 'details',
          align: 'start',
          value: 'details',
          sortable: false,
        },
        {
          text: 'complete_pay_amt',
          align: 'start',
          value: 'complete_pay_amt',
          sortable: false,
        },
        {
          text: 'complete_pay_type',
          align: 'start',
          value: 'complete_pay_type',
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
      deletePosting: 'work/ApiActionDeletePosting',
    }),
    fetchTableData() {
      const { page, itemsPerPage } = this.options
      this.loading = true
      this.getPostingsPage({ page: page - 1, count: itemsPerPage }).then(
        ({ payload }) => {
          if (payload) {
            // this.totalItems = payload.count
          }
          this.loading = false
        }
      )
    },
    newItem() {
      this.$router.push('/postings/new')
    },
    payItem(item) {
      this.$router.push(`/postings/id/${item.posting_id}`)
    },
    deleteItem(item) {
      this.currentItem = item
      this.dialog = true
    },
    cancelDelete() {
      this.currentItem = {}
      this.dialog = false
    },
    confirmDelete() {
      this.deleting = true
      this.deletePosting({ posting_id: this.currentItem.posting_id }).then(
        ({ error }) => {
          this.currentItem = {}
          this.dialog = false
          this.deleting = false
          if (!error) {
            this.$toast.success('Posting deleted successfully.')
          } else {
            this.$toast.error(`Error deleting the posting. ${error.message}`)
          }
        }
      )
    },
  },
}
</script>
