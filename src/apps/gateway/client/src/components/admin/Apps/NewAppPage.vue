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
        v-model="fee"
        type="text"
        name="fee"
        label="Fee Percentage"
        required
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
      />
    </v-form>

    <v-card-actions>
      <v-progress-linear
        v-if="creating"
        :active="true"
        :indeterminate="true"
        color="primary"
      />
      <template v-else>
        <v-spacer />
        <v-btn depressed small class="mr-2" @click="cancelNewApp">Cancel</v-btn>
        <v-btn color="primary" depressed small @click="onSubmit">
          Save App
        </v-btn>
      </template>
    </v-card-actions>
  </AppLayoutPanel>
</template>

<script>
import { mapActions } from 'vuex'
import AppLayoutPanel from '@/components/admin/AppLayoutPanel.vue'

export default {
  name: 'NewAppPage',
  components: {
    AppLayoutPanel,
  },
  data() {
    return {
      name: '',
      fee: '',
      imageUrl: '',
      description: '',
      valid: true,
      rules: {
        name: [(v) => v.length >= 4 || 'Min 4 characters'],
      },
      creating: false,
    }
  },
  methods: {
    ...mapActions({
      apiCreateApp: 'apps/ApiActionCreateApp',
    }),
    cancelNewApp() {
      this.$router.push({ name: 'Apps' })
    },
    onSubmit() {
      if (!this.$refs.form.validate()) {
        return
      }

      this.creating = true
      this.apiCreateApp({
        name: this.name,
        fee: this.fee,
        imageUrl: this.imageUrl,
        description: this.description,
      }).then(({ error }) => {
        this.creating = false
        if (!error) {
          this.$router.push({ name: 'Apps' })
          this.$toast.success('App created successfully.')
        } else {
          this.$toast.error(`Error creating the app. ${error.message}`)
        }
      })
    },
  },
}
</script>
