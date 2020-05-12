<template>
  <va-page-not-found class="va-page-not-found-large-text">
    <div slot="image" class="va-page-not-found-large-text__number">404</div>
  </va-page-not-found>
</template>

<script>
import VaPageNotFound from './VaPageNotFound'

export default {
  name: 'VaPageNotFoundLargeText',
  components: {
    VaPageNotFound,
  },
}
</script>

<style lang="scss">
.va-page-not-found-large-text {
  &__number {
    font-size: 21rem;
    color: $white;
    font-weight: 600;

    @include media-breakpoint-down(xs) {
      font-size: 12rem;
    }
  }
}
</style>
