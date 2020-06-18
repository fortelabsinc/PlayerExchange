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

      <v-card-actions>
        <v-spacer />
        <v-btn color="error" depressed small @click="dialog = true">
          Delete Guild
        </v-btn>
      </v-card-actions>

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

export default {
  name: 'GuildPage',
  components: {
    AppLayoutPanel,
    EditField,
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
  },
}
</script>
