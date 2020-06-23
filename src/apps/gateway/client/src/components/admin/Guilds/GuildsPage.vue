<template>
  <AppLayoutPanel>
    <v-toolbar flat color="white">
      <v-toolbar-title>Guilds</v-toolbar-title>
      <v-spacer />
      <v-btn color="primary" class="mb-2" @click="newItem()">New Guild</v-btn>
    </v-toolbar>

    <v-data-table
      fixed-header
      loading-text="Loading..."
      :headers="headers"
      :items="guildsList"
      :loading="loading"
      :options.sync="options"
      :server-items-length="totalItems"
    >
      <template v-slot:item.order_id="{ item }">
        <router-link :to="`/guilds/id/${item.guild_id}`">
          {{ item.guild_id }}
        </router-link>
      </template>

      <template v-slot:item.actions="{ item }">
        <v-icon small class="mr-2" @click="editItem(item)">
          mdi-pencil
        </v-icon>
        <v-icon small @click="deleteItem(item)">
          mdi-delete
        </v-icon>
      </template>
    </v-data-table>

    <v-dialog v-model="dialog" :persistent="deleting" max-width="600px">
      <v-card>
        <v-card-title>
          Are you sure you want to delete this guild?
        </v-card-title>
        <v-divider class="mb-2" />
        <v-card-text>
          <p>Guild ID: {{ currentItem.guild_id }}</p>
          <p>Name: {{ currentItem.name }}</p>
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
  </AppLayoutPanel>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import AppLayoutPanel from '@/components/admin/AppLayoutPanel.vue'

export default {
  name: 'GuildsPage',
  components: {
    AppLayoutPanel,
  },
  data() {
    return {
      dialog: false,
      currentItem: {},
      loading: false,
      deleting: false,
      totalItems: 0,
      options: {},
    }
  },
  computed: {
    ...mapGetters({
      guildsList: 'guilds/getGuildsList',
      guildsItemsPerPage: 'guilds/getGuildsItemsPerPage',
    }),
    headers() {
      return [
        {
          text: 'ID',
          align: 'start',
          value: 'guild_id',
          sortable: false,
        },
        {
          text: 'Name',
          align: 'start',
          value: 'name',
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
    this.options.itemsPerPage = this.guildsItemsPerPage
    // this.fetchTableData()
  },
  methods: {
    ...mapActions({
      getGuildsPage: 'guilds/ApiActionGetGuildsPage',
      deleteGuild: 'guilds/ApiActionDeleteGuild',
    }),
    fetchTableData() {
      const { page, itemsPerPage } = this.options
      this.loading = true
      this.getGuildsPage({ page: page - 1, count: itemsPerPage }).then(
        ({ payload }) => {
          if (payload) {
            this.totalItems = payload.count
          }
          this.loading = false
        }
      )
    },
    newItem() {
      this.$router.push('/guilds/new')
    },
    editItem(item) {
      this.$router.push(`/guilds/id/${item.guild_id}`)
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
      this.deleteGuild({ guild_id: this.currentItem.guild_id }).then(
        ({ error }) => {
          this.currentItem = {}
          this.dialog = false
          this.deleting = false
          if (!error) {
            this.$toast.success('Guild deleted successfully.')
          } else {
            this.$toast.error(`Error deleting the guild. ${error.message}`)
          }
        }
      )
    },
  },
}
</script>
