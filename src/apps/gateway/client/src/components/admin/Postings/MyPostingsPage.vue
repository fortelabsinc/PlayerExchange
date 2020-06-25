<template>
  <AppLayoutPanel>
    <v-toolbar flat color="white">
      <v-toolbar-title>My Postings</v-toolbar-title>
      <v-spacer />
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
        <v-menu offset-y>
          <template v-slot:activator="{ on, attrs }">
            <v-btn
              class="mx-3"
              color="primary"
              small
              dark
              outlined
              v-bind="attrs"
              v-on="on"
            >
              Pay
            </v-btn>
          </template>
          <v-list>
            <v-list-item
              v-for="type in payOptions"
              :key="type"
              @click="payItem(item, type)"
            >
              <v-list-item-title>{{ type }}</v-list-item-title>
            </v-list-item>
          </v-list>
        </v-menu>
        <v-icon small color="red" @click="deleteItem(item)">
          mdi-delete
        </v-icon>
      </template>
    </v-data-table>

    <v-dialog v-model="dialogDelete" :persistent="deleting" max-width="600px">
      <v-card>
        <v-card-title>
          Are you sure you want to delete this posting?
        </v-card-title>
        <v-divider class="mb-2" />
        <v-card-text>
          <p>Post ID: {{ currentItem.post_id }}</p>
          <p>User ID: {{ currentItem.user_id }}</p>
          <p>Game: {{ games[currentItem.game_id] }}</p>
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

    <PostDetails v-model="dialog" :posting="currentItem" />
    <MakePayment v-model="dialogPayment" :data="paymentData" />
  </AppLayoutPanel>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import AppLayoutPanel from '@/components/admin/AppLayoutPanel.vue'
import MakePayment from '@/components/common/MakePayment.vue'
import PostDetails from '@/components/admin/Postings/PostDetails.vue'

export default {
  name: 'MyPostingsPage',
  components: {
    AppLayoutPanel,
    MakePayment,
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
      dialogDelete: false,
      dialogPayment: false,
      currentItem: {},
      loading: false,
      deleting: false,
      totalItems: 0,
      options: {},
      payOptions: ['Confirm', 'Complete', 'Bonus'],
      paymentData: null,
      games: {},
    }
  },
  computed: {
    ...mapGetters({
      userId: 'auth/getUserId',
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
      getPostingsPage: 'work/ApiActionGetUserPostingsPage',
      appNames: 'app/ApiActionFetchAllAppNames',
      deletePosting: 'work/ApiActionDeletePosting',
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

      this.getPostingsPage({
        user_id: this.userId,
        page: page - 1,
        count: itemsPerPage,
      }).then(({ payload }) => {
        if (payload) {
          this.totalItems = payload.count
        }
        this.loading = false
      })
    },
    newItem() {
      this.$router.push('/postings/new')
    },
    payItem(item, type) {
      this.paymentData = {
        typeLabel: type,
        postId: item.post_id,
        postType: 'post',
      }
      if (type === 'Confirm') {
        this.paymentData.amount = item.confirm_pay_amt
        this.paymentData.type = item.confirm_pay_type
      } else if (type === 'Complete') {
        this.paymentData.amount = item.complete_pay_amt
        this.paymentData.type = item.complete_pay_type
      } else {
        this.paymentData.amount = item.bonus_pay_amt
        this.paymentData.type = item.bonus_pay_type
      }
      this.dialogPayment = true
    },
    deleteItem(item) {
      this.currentItem = item
      this.dialogDelete = true
    },
    cancelDelete() {
      this.currentItem = {}
      this.dialogDelete = false
    },
    confirmDelete() {
      this.deleting = true
      this.deletePosting({ posting_id: this.currentItem.posting_id }).then(
        ({ error }) => {
          this.currentItem = {}
          this.dialogDelete = false
          this.deleting = false
          if (!error) {
            this.$toast.success('Posting deleted successfully.')
          } else {
            this.$toast.error(`Error deleting the posting. ${error.message}`)
          }
        }
      )
    },
    showDetails(item) {
      this.currentItem = item
      this.dialog = true
    },
  },
}
</script>
