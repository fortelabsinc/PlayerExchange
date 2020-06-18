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

    <v-card-actions>
      <v-progress-linear
        v-if="creating"
        :active="true"
        :indeterminate="true"
        color="primary"
      />
      <template v-else>
        <v-spacer />
        <v-btn depressed small class="mr-2" @click="cancelNewGuild">
          Cancel
        </v-btn>
        <v-btn color="primary" depressed small @click="onSubmit">
          Save Guild
        </v-btn>
      </template>
    </v-card-actions>
  </AppLayoutPanel>
</template>

<script>
import { mapActions } from 'vuex'
import AppLayoutPanel from '@/components/admin/AppLayoutPanel.vue'

export default {
  name: 'NewGuildPage',
  components: {
    AppLayoutPanel,
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
  },
}
</script>
