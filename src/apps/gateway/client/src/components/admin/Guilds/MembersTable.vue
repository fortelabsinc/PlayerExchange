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
    >
      <template v-slot:item.name="{ item }">
        {{ users[item.user_id] }}
      </template>

      <template v-slot:item.actions="{ item }">
        <v-btn
          v-if="isOwner"
          color="red"
          outlined
          small
          @click="removeMember(item)"
        >
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
          <p>Name: {{ users[currentItem.user_id] }}</p>
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
import { map } from 'lodash'

export default {
  name: 'MembersTable',
  props: ['guildId', 'ownerId', 'value'],
  data() {
    return {
      dialog: false,
      currentItem: {},
      loading: false,
      removing: false,
      totalItems: 0,
      users: {},
    }
  },
  computed: {
    ...mapGetters({
      membersListGet: 'guilds/getGuildMembers',
      membersItemsPerPage: 'guilds/getMembersItemsPerPage',
      userId: 'auth/getUserId',
    }),
    membersList() {
      const list = this.guildId ? this.membersListGet(this.guildId) : this.value
      return map(list, (stake, user_id) => ({ user_id, stake }))
    },
    isOwner() {
      return this.ownerId === this.userId
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
          text: 'Guild Points',
          align: 'start',
          value: 'stake',
          sortable: false,
        },
        ...(this.isOwner
          ? [{ text: '', align: 'end', value: 'actions', sortable: false }]
          : []),
      ]
    },
  },
  mounted() {
    if (this.membersList) {
      this.getAllUserNames({
        ids: this.membersList.map((p) => p.user_id),
      }).then(({ payload }) => {
        if (payload) {
          this.users = payload
        }
      })
    }
  },
  methods: {
    ...mapActions({
      getAllUserNames: 'auth/ApiActionFetchAllUserNames',
      removeGuildMember: 'guilds/ApiActionRemoveGuildMember',
    }),
    removeMember(item) {
      if (!this.guildId) {
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
      this.removeGuildMember({
        guild_id: this.guildId,
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
        this.$emit('removed')
      })
    },
  },
}
</script>
