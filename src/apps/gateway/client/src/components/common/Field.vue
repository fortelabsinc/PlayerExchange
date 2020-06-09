<template>
  <v-text-field
    :value="value"
    :readonly="true"
    :label="label"
    v-bind="$attrs"
    :append-icon="isMock ? 'mdi-alert-circle' : undefined"
  />
</template>

<script>
export default {
  name: 'Field',
  props: ['value', 'label', 'isMock'],
}
</script>
