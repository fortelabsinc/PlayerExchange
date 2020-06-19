<template>
  <AppLayoutPanel>
    <v-progress-linear
      v-if="loading || !guild"
      :active="true"
      :indeterminate="true"
      color="primary"
    />
    <template v-else>
      <EditField :value="guild.guild_id" disabled label="Guild ID" />
      <EditField
        :value="guild.name"
        :onSave="saveName"
        :isSaving="savingName"
        label="Name"
      />
      <EditField
        :value="guild.imageUrl"
        :onSave="saveImageUrl"
        :isSaving="savingImageUrl"
        label="Image URL"
      />
      <EditField
        :value="guild.description"
        :onSave="saveDescription"
        :isSaving="savingDescription"
        label="Description"
      />

      <MembersTable :guild_id="guild.guild_id" />

      <v-card-actions>
        <v-spacer />
        <v-btn color="primary" depressed small @click="dialogMember = true">
          Add Member
        </v-btn>
        <v-btn color="error" depressed small @click="dialog = true">
          Delete Guild
        </v-btn>
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

      <v-dialog v-model="dialog" :persistent="deleting" max-width="600px">
        <v-card>
          <v-card-title>
            Are you sure you want to delete this guild?
          </v-card-title>
          <v-divider class="mb-2" />
          <v-card-text>
            <p>Guild ID: {{ guild.guild_id }}</p>
            <p>Name: {{ guild.name }}</p>
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
              <v-btn text @click="dialog = false">
                Cancel
              </v-btn>
              <v-btn color="primary" text @click="confirmDelete">
                Confirm
              </v-btn>
            </template>
          </v-card-actions>
        </v-card>
      </v-dialog>
    </template>
  </AppLayoutPanel>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import AppLayoutPanel from '@/components/admin/AppLayoutPanel.vue'
import EditField from '@/components/common/EditField.vue'
import MembersTable from '@/components/admin/Guilds/MembersTable.vue'

export default {
  name: 'GuildPage',
  components: {
    AppLayoutPanel,
    EditField,
    MembersTable,
  },
  data() {
    return {
      dialog: false,
      loading: true,
      guild: null,
      savingName: false,
      savingDescription: false,
      savingImageUrl: false,
      deleting: false,
      dialogMember: false,
      adding: false,
      currentMember: {},
    }
  },
  computed: {
    ...mapGetters({
      getGuild: 'guilds/getGuildById',
    }),
  },
  watch: {
    getGuild() {
      this.guild = this.getGuild(this.$route.params.id)
    },
  },
  mounted() {
    this.loading = true
    this.apiGetGuildById({ guild_id: this.$route.params.id }).then(
      () => (this.loading = false)
    )
  },
  methods: {
    ...mapActions({
      apiGetGuildById: 'guilds/ApiActionGetGuildById',
      apiEditGuildName: 'guilds/ApiActionEditGuildName',
      apiEditGuildDescription: 'guilds/ApiActionEditGuildDescription',
      apiEditGuildImageUrl: 'guilds/ApiActionEditGuildImageUrl',
      deleteGuild: 'guilds/ApiActionDeleteGuild',
      addGuildMember: 'guilds/ApiActionAddGuildMember',
    }),
    saveName(name) {
      this.savingName = true
      this.apiEditGuildName({ guild_id: this.guild.guild_id, name }).then(
        ({ error }) => {
          this.savingName = false
          if (!error) {
            this.$toast.success('Name saved successfully.')
          } else {
            this.$toast.error(`Error saving Name. ${error.message}`)
          }
        }
      )
    },
    saveDescription(description) {
      this.savingDescription = true
      this.apiEditGuildDescription({
        guild_id: this.guild.guild_id,
        description,
      }).then(({ error }) => {
        this.savingDescription = false
        if (!error) {
          this.$toast.success('Revue Split saved successfully.')
        } else {
          this.$toast.error(`Error saving Revue Split. ${error.message}`)
        }
      })
    },
    saveImageUrl(imageUrl) {
      this.savingImageUrl = true
      this.apiEditGuildImageUrl({
        guild_id: this.guild.guild_id,
        imageUrl,
      }).then(({ error }) => {
        this.savingImageUrl = false
        if (!error) {
          this.$toast.success('Image URL saved successfully.')
        } else {
          this.$toast.error(`Error saving ImageURL. ${error.message}`)
        }
      })
    },
    confirmDelete() {
      this.deleting = true
      this.deleteGuild({ guild_id: this.guild.guild_id }).then(({ error }) => {
        this.dialog = false
        this.deleting = false
        if (!error) {
          this.$toast.success('Guild deleted successfully.')
          this.$router.push({ name: 'Guilds' })
        } else {
          this.$toast.error(`Error deleting the guild. ${error.message}`)
        }
      })
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
      this.addGuildMember({
        guild_id: this.guild.guild_id,
        user_id: this.currentMember.user_id,
      }).then(({ error }) => {
        this.currentMember = {}
        this.dialogMember = false
        this.adding = false
        if (!error) {
          this.$toast.success('Guild member added successfully.')
        } else {
          this.$toast.error(`Error adding the guild member. ${error.message}`)
        }
      })
    },
  },
}
</script>
