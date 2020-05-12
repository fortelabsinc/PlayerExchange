<template>
  <div class="rating">
    <div class="row">
      <div class="flex md6 xs12">
        <va-card :title="$t('rating.singleIcon')">
          <va-rating v-model="value" color="danger" icon="fa fa-bug" />
        </va-card>
      </div>
      <div class="flex md6 xs12">
        <va-card :title="$t('rating.twoIcons')">
          <va-rating
            v-model="value"
            icon="fa fa-bell-slash"
            empty-icon="fa fa-bell"
          />
        </va-card>
      </div>
      <div class="flex md6 xs12">
        <va-card :title="$t('rating.small')">
          <va-rating v-model="value" size="small" color="warning" />
        </va-card>
      </div>
      <div class="flex md6 xs12">
        <va-card :title="$t('rating.large')">
          <va-rating v-model="value" size="large" color="info" />
        </va-card>
      </div>
      <div class="flex md6 xs12">
        <va-card :title="$t('rating.numbers')">
          <va-rating v-model="value" numbers />
        </va-card>
      </div>
      <div class="flex md6 xs12">
        <va-card :title="$t('rating.halves')">
          <va-rating
            v-model="value"
            color="warning"
            empty-icon="fa fa-star-o"
            halves
          />
        </va-card>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Rating',
  data() {
    return {
      value: 2,
    }
  },
}
</script>
