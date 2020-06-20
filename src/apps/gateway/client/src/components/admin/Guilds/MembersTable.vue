<template>
  <div>
    <v-toolbar flat color="white">
      <v-toolbar-title>Members</v-toolbar-title>
      <v-spacer />
    </v-toolbar>

    <v-data-table
      fixed-header
      loading-text="Loading..."
      :headers="headers"
      :items="membersList"
      :loading="loading"
      :options.sync="guild_id ? options : undefined"
      :server-items-length="guild_id ? totalItems : undefined"
    >
      <template v-slot:item.actions="{ item }">
        <v-btn color="red" text @click="removeMember(item)">
          Remove
        </v-btn>
      </template>
    </v-data-table>

    <v-dialog v-model="dialog" :persistent="removing" max-width="600px">
      <v-card>
        <v-card-title>
          Are you sure you want to remove this member?
        </v-card-title>
        <v-divider class="mb-2" />
        <v-card-text>
          <p>User ID: {{ currentItem.user_id }}</p>
          <p>Name: {{ currentItem.name }}</p>
        </v-card-text>
        <v-card-actions>
          <v-progress-linear
            v-if="removing"
            height="25"
            :active="true"
            :indeterminate="true"
            color="primary"
          >
            <strong class="white--text">Removing</strong>
          </v-progress-linear>
          <template v-else>
            <v-spacer />
            <v-btn text @click="cancelRemove">
              Cancel
            </v-btn>
            <v-btn color="primary" text @click="confirmRemove">
              Confirm
            </v-btn>
          </template>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'

export default {
  name: 'MembersTable',
  props: ['guild_id', 'value'],
  data() {
    return {
      // membersList: [],
      dialog: false,
      currentItem: {},
      loading: false,
      removing: false,
      totalItems: 0,
      options: {},
    }
  },
  computed: {
    ...mapGetters({
      membersListGet: 'guilds/getGuildMembers',
      membersItemsPerPage: 'guilds/getMembersItemsPerPage',
    }),
    membersList() {
      return this.guild_id ? this.membersListGet(this.guild_id) : this.value
    },
    headers() {
      return [
        {
          text: 'User ID',
          align: 'start',
          value: 'user_id',
          sortable: false,
        },
        {
          text: 'Name',
          align: 'start',
          value: 'name',
          sortable: false,
        },
        {
          text: 'Bio',
          align: 'start',
          value: 'bio',
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
    if (this.guild_id) {
      this.options.itemsPerPage = this.membersItemsPerPage
      this.fetchTableData()
    }
  },
  methods: {
    ...mapActions({
      getGuildMembers: 'guilds/ApiActionFetchGuildMembers',
      removeGuildMembers: 'guilds/ApiActionRemoveGuildMember',
    }),
    fetchTableData() {
      const { page, itemsPerPage } = this.options
      this.loading = true
      this.getGuildMembers({
        guild_id: this.guild_id,
        page: page - 1,
        count: itemsPerPage,
      }).then(({ payload }) => {
        if (payload) {
          // this.totalItems = payload.count
        }
        this.loading = false
      })
    },
    removeMember(item) {
      if (!this.guild_id) {
        this.$emit('removed', item)
        return
      }

      this.currentItem = item
      this.dialog = true
    },
    cancelRemove() {
      this.currentItem = {}
      this.dialog = false
    },
    confirmRemove() {
      this.removing = true
      this.removeGuildMembers({
        guild_id: this.guild_id,
        user_id: this.currentItem.user_id,
      }).then(({ error }) => {
        this.currentItem = {}
        this.dialog = false
        this.removing = false
        if (!error) {
          this.$toast.success('Member removed successfully.')
        } else {
          this.$toast.error(`Error removing the member. ${error.message}`)
        }
      })
    },
  },
}
</script>
