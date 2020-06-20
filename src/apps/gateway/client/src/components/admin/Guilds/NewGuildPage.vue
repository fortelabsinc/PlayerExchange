<template>
  <AppLayoutPanel>
    <v-form ref="form" v-model="valid" lazy-validation>
      <v-text-field
        v-model="name"
        type="text"
        name="name"
        label="Name"
        required
        :rules="rules.name"
      />
      <v-text-field
        v-model="imageUrl"
        type="text"
        name="imageUrl"
        label="ImageUrl"
      />
      <v-text-field
        v-model="description"
        type="text"
        name="description"
        label="Description"
        required
      />
    </v-form>

    <MembersTable :value="members" @removed="onMemberRemoved" />

    <v-card-actions>
      <v-progress-linear
        v-if="creating"
        :active="true"
        :indeterminate="true"
        color="primary"
      />
      <template v-else>
        <v-btn color="primary" depressed small @click="dialogMember = true">
          Add Member
        </v-btn>
        <v-spacer />
        <v-btn depressed small class="mr-2" @click="cancelNewGuild">
          Cancel
        </v-btn>
        <v-btn color="primary" depressed small @click="onSubmit">
          Save Guild
        </v-btn>
      </template>
    </v-card-actions>

    <v-dialog v-model="dialogMember" :persistent="adding" max-width="600px">
      <v-card>
        <v-card-title>
          Add new guild member
        </v-card-title>
        <v-divider class="mb-2" />
        <v-card-text>
          <v-text-field
            v-model="currentMember.user_id"
            type="text"
            name="user_id"
            label="User ID"
          />
        </v-card-text>
        <v-card-actions>
          <v-progress-linear
            v-if="adding"
            height="25"
            :active="true"
            :indeterminate="true"
            color="primary"
          >
            <strong class="white--text">Adding</strong>
          </v-progress-linear>
          <template v-else>
            <v-spacer />
            <v-btn text @click="cancelAdd">
              Cancel
            </v-btn>
            <v-btn color="primary" text @click="confirmAdd">
              Add
            </v-btn>
          </template>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </AppLayoutPanel>
</template>

<script>
import { mapActions } from 'vuex'
import AppLayoutPanel from '@/components/admin/AppLayoutPanel.vue'
import MembersTable from '@/components/admin/Guilds/MembersTable.vue'
import { filter, map } from 'lodash'

export default {
  name: 'NewGuildPage',
  components: {
    AppLayoutPanel,
    MembersTable,
  },
  data() {
    return {
      name: '',
      imageUrl: '',
      description: '',
      valid: true,
      rules: {
        name: [(v) => v.length >= 4 || 'Min 4 characters'],
      },
      creating: false,
      members: [],
      dialogMember: false,
      adding: false,
      currentMember: {},
    }
  },
  methods: {
    ...mapActions({
      apiCreateGuild: 'guilds/ApiActionCreateGuild',
    }),
    cancelNewGuild() {
      this.$router.push({ name: 'Guilds' })
    },
    onSubmit() {
      if (!this.$refs.form.validate()) {
        return
      }

      this.creating = true
      this.apiCreateGuild({
        name: this.name,
        description: this.description,
        imageUrl: this.imageUrl,
        members: map(this.members, (member) => member.user_id),
      }).then(({ error }) => {
        this.creating = false
        if (!error) {
          this.$router.push({ name: 'Guilds' })
          this.$toast.success('Guild created successfully.')
        } else {
          this.$toast.error(`Error creating the guild. ${error.message}`)
        }
      })
    },
    onMemberRemoved(item) {
      this.members = filter(
        this.members,
        (member) => member.user_id !== item.user_id
      )
    },
    cancelAdd() {
      this.dialogMember = false
      this.currentMember = {}
    },
    confirmAdd() {
      if (!this.currentMember.user_id) {
        return
      }

      this.adding = true
      // TODO: fetch user data from API
      this.members.push({
        user_id: this.currentMember.user_id,
        name: 'TODO: Get name from API',
      })

      this.adding = false
      this.dialogMember = false
    },
  },
}
</script>
