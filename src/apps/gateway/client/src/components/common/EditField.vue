<template>
  <component
    :is="component"
    v-model="content"
    :readonly="!editEnable"
    :label="label"
    auto-grow
    v-bind="$attrs"
  >
    <v-btn-toggle
      v-if="$attrs.disabled === undefined"
      slot="append"
      dense
      group
    >
      <template v-if="!isSaving && editEnable">
        <v-btn small @click="confirmEdit">
          <v-icon small icon color="primary">mdi-check</v-icon>
        </v-btn>
        <v-btn small icon @click="cancelEdit">
          <v-icon small color="error">mdi-close</v-icon>
        </v-btn>
      </template>

      <v-btn v-else-if="!isSaving" small icon @click="editEnable = !editEnable">
        <v-icon small>mdi-pencil</v-icon>
      </v-btn>
      <v-progress-circular
        v-else
        :style="{ marginRight: '8px' }"
        :size="22"
        color="primary"
        indeterminate
      />
    </v-btn-toggle>
  </component>
</template>

<script>
import { VTextField, VTextarea } from 'vuetify/lib'
export default {
  name: 'EditField',
  props: ['value', 'label', 'isTextarea', 'onSave', 'isSaving'],
  data() {
    return {
      editEnable: false,
      content: this.value,
    }
  },
  watch: {
    value(val) {
      this.content = val
    },
    editEnable(val) {
      if (val && !this.isSaving) {
        this.content = this.value
      }
    },
    isSaving(val) {
      if (!val) {
        this.content = this.value
      }
    },
  },
  computed: {
    component() {
      return this.isTextarea === undefined ? VTextField : VTextarea
    },
  },
  methods: {
    cancelEdit() {
      this.editEnable = false
      this.content = this.value
    },
    confirmEdit() {
      this.editEnable = false
      this.onSave && this.onSave(this.content)
    },
  },
}
</script>
