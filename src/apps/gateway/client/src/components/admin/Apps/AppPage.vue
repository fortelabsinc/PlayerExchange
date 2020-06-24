<template>
  <AppLayoutPanel>
    <v-progress-linear
      v-if="loading || !app"
      :active="true"
      :indeterminate="true"
      color="primary"
    />
    <template v-else>
      <EditField :value="app.game_id" disabled label="App ID" />
      <EditField
        :value="app.fee"
        :onSave="saveName"
        :isSaving="savingName"
        label="Name"
      />
      <EditField
        :value="app.revueSplit"
        :onSave="saveRevueSplit"
        :isSaving="savingRevueSplit"
        label="Revue Split"
      />
      <EditField
        :value="app.image"
        :onSave="saveImageUrl"
        :isSaving="savingImageUrl"
        label="Image URL"
      />

      <v-card-actions>
        <v-spacer />
        <v-btn color="error" depressed small @click="dialog = true">
          Delete App
        </v-btn>
      </v-card-actions>

      <v-dialog v-model="dialog" :persistent="deleting" max-width="600px">
        <v-card>
          <v-card-title>
            Are you sure you want to delete this app?
          </v-card-title>
          <v-divider class="mb-2" />
          <v-card-text>
            <p>App ID: {{ app.game_id }}</p>
            <p>Name: {{ app.name }}</p>
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
  name: 'AppPage',
  components: {
    AppLayoutPanel,
    EditField,
  },
  data() {
    return {
      dialog: false,
      loading: true,
      app: null,
      savingName: false,
      savingRevueSplit: false,
      savingImageUrl: false,
      deleting: false,
    }
  },
  computed: {
    ...mapGetters({
      getApp: 'apps/getAppById',
    }),
  },
  watch: {
    getApp() {
      this.app = this.getApp(this.$route.params.game_id)
    },
  },
  mounted() {
    this.loading = true
    this.apiGetAppById({ game_id: this.$route.params.id }).then(
      () => (this.loading = false)
    )
  },
  methods: {
    ...mapActions({
      apiGetAppById: 'apps/ApiActionGetAppById',
      apiEditAppName: 'apps/ApiActionEditAppName',
      apiEditAppRevueSplit: 'apps/ApiActionEditAppRevueSplit',
      apiEditAppImageUrl: 'apps/ApiActionEditAppImageUrl',
      deleteApp: 'apps/ApiActionDeleteApp',
    }),
    saveName(name) {
      this.savingName = true
      this.apiEditAppName({ game_id: this.app.game_id, name }).then(
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
    saveRevueSplit(revueSplit) {
      this.savingRevueSplit = true
      this.apiEditAppRevueSplit({ game_id: this.app.game_id, revueSplit }).then(
        ({ error }) => {
          this.savingRevueSplit = false
          if (!error) {
            this.$toast.success('Revue Split saved successfully.')
          } else {
            this.$toast.error(`Error saving Revue Split. ${error.message}`)
          }
        }
      )
    },
    saveImageUrl(imageUrl) {
      this.savingImageUrl = true
      this.apiEditAppImageUrl({ game_id: this.app.game_id, imageUrl }).then(
        ({ error }) => {
          this.savingImageUrl = false
          if (!error) {
            this.$toast.success('Image URL saved successfully.')
          } else {
            this.$toast.error(`Error saving ImageURL. ${error.message}`)
          }
        }
      )
    },
    confirmDelete() {
      this.deleting = true
      this.deleteApp({ game_id: this.app.game_id }).then(({ error }) => {
        this.dialog = false
        this.deleting = false
        if (!error) {
          this.$toast.success('App deleted successfully.')
          this.$router.push({ name: 'Apps' })
        } else {
          this.$toast.error(`Error deleting the app. ${error.message}`)
        }
      })
    },
  },
}
</script>
