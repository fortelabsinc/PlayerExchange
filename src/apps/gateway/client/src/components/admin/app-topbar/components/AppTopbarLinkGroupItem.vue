<template>
  <router-link
    class="app-topbar-link-group-item"
    :class="computedClass"
    :to="to"
    :style="computedStyles"
    @mouseenter.native="updateHoverState(true)"
    @mouseleave.native="updateHoverState(false)"
  >
    <div class="app-topbar-link-group-item__in">
      <va-icon
        class="app-topbar-link-group-item__icon"
        :name="icon"
        :style="computedIconStyles"
      />
      <span class="app-topbar-link-group-item__title">
        {{ title }}
      </span>
    </div>
  </router-link>
</template>

<script>
import { ColorThemeMixin } from '../../../../services/vuestic-ui'

export default {
  name: 'AppTopbarLinkGroupItem',
  components: {},
  mixins: [ColorThemeMixin],
  props: {
    to: [String, Array, Object],
    color: {
      type: String,
      default: 'secondary',
    },
    icon: {
      type: String,
      default: 'fa fa-pencil',
    },
    title: {
      type: String,
      default: '',
    },
    isActive: {
      type: Boolean,
      default: false,
    },
  },
  data() {
    return {
      isHover: false,
    }
  },
  computed: {
    computedStyles() {
      return {
        color: this.isHover || this.isActive ? this.$themes.primary : 'inherit',
      }
    },
    computedIconStyles() {
      return {
        color:
          this.isHover || this.isActive
            ? this.$themes.primary
            : this.$themes.info,
      }
    },
    computedClass() {
      return {
        'app-topbar-link-group-item--active': this.isActive,
      }
    },
  },
  methods: {
    updateHoverState(hoverState) {
      this.isHover = hoverState
    },
  },
}
</script>

<style lang="scss">
.app-topbar-link-group-item {
  display: inline-block;
  padding: 0.3rem 0;

  &--active {
  }

  &__in {
  }

  &__icon {
    margin-right: 0.25rem;
    color: inherit;
  }
}
</style>
