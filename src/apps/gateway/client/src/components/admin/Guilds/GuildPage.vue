<template>
  <div>
    <AppLayoutPanel v-if="loading || !guild">
      <v-progress-linear :active="true" :indeterminate="true" color="primary" />
    </AppLayoutPanel>
    <template v-else>
      <v-tabs v-model="tab" background-color="normal">
        <v-tab>Guild Details</v-tab>
        <v-tab>Guild Currencies</v-tab>
      </v-tabs>
      <v-tabs-items v-model="tab">
        <v-tab-item key="0">
          <AppLayoutPanel>
            <EditField :value="guild.guild_id" disabled label="Guild ID" />
            <EditField
              :value="guild.name"
              :onSave="saveName"
              :isSaving="savingName"
              label="Name"
            />
            <v-text-field
              v-model="guild.pay_id"
              type="text"
              name="pay_id"
              label="Pay ID"
              readonly
            />
            <v-img
              v-if="guild.image"
              :src="guild.image"
              aspect-ratio="1"
              height="200"
              width="200"
            />
            <EditField
              :value="guild.image"
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

            <MembersTable
              :guild_id="guild.guild_id"
              @removed="onMemberRemoved"
            />

            <v-card-actions>
              <v-btn
                color="primary"
                depressed
                small
                @click="dialogMember = true"
              >
                Add Member
              </v-btn>
              <v-spacer />
              <v-btn color="error" depressed small @click="dialog = true">
                Delete Guild
              </v-btn>
            </v-card-actions>

            <v-dialog
              v-model="dialogMember"
              :persistent="adding"
              max-width="600px"
            >
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
                  <v-text-field
                    v-model="currentMember.stake"
                    type="text"
                    name="stake"
                    label="Guild Points"
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
          </AppLayoutPanel>
        </v-tab-item>

        <v-tab-item key="1">
          <CurrenciesPanel :guildId="guild.guild_id" />
        </v-tab-item>
      </v-tabs-items>
    </template>
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import AppLayoutPanel from '@/components/admin/AppLayoutPanel.vue'
import EditField from '@/components/common/EditField.vue'
import MembersTable from '@/components/admin/Guilds/MembersTable.vue'
import CurrenciesPanel from '@/components/common/GuildCurrenciesPanel.vue'

export default {
  name: 'GuildPage',
  components: {
    AppLayoutPanel,
    EditField,
    MembersTable,
    CurrenciesPanel,
  },
  data() {
    return {
      tab: null,
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
    this.fetchGuildData()
  },
  methods: {
    ...mapActions({
      apiGetGuildById: 'guilds/ApiActionGetGuildById',
      apiEditGuildName: 'guilds/ApiActionEditGuildName',
      apiEditGuildDescription: 'guilds/ApiActionEditGuildDescription',
      apiEditGuildImageUrl: 'guilds/ApiActionEditGuildImageUrl',
      deleteGuild: 'guilds/ApiActionDeleteGuild',
      addGuildMember: 'guilds/ApiActionAddGuildMember',
      setGuildMemberStake: 'guilds/ApiActionGuildMemberStake',
    }),
    fetchGuildData() {
      this.loading = true
      this.apiGetGuildById({ guild_id: this.$route.params.id }).then(() => {
        this.loading = false
      })
    },
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
        const guild_id = this.guild.guild_id
        const user_id = this.currentMember.user_id
        const stake = this.currentMember.stake
        const self = this

        this.currentMember = {}
        this.dialogMember = false
        this.adding = false
        if (!error) {
          this.$toast.success('Guild member added successfully.')
        } else {
          this.$toast.error(`Error adding the guild member. ${error.message}`)
        }
        this.setGuildMemberStake({ guild_id, user_id, stake }).then(
          ({ error }) => {
            if (error) {
              this.$toast.error(
                `Error seting the guild member stake. ${error.message}`
              )
            }
            self.fetchGuildData()
          }
        )
      })
    },
    onMemberRemoved() {
      this.fetchGuildData()
    },
  },
}
</script>
