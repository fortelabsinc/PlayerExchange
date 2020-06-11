<template>
  <va-dropdown class="color-dropdown" offset="0, 13px">
    <va-icon-color
      slot="anchor"
      class="color-dropdown__icon"
      :color="contextConfig.invertedColor ? $themes.gray : 'white'"
    />
    <div class="color-dropdown__content pl-4 pr-4 pt-2 pb-2">
      <va-button-toggle
        v-model="selectedTheme"
        outline
        small
        :options="modeOptions"
        style="max-width: 100%;"
      />
      <va-dropdown class="color-picker-dropdown mt-1 mb-1">
        <va-badge
          slot="anchor"
          class="color-picker-dropdown__badge"
          color="primary"
        >
          Primary
        </va-badge>
        <va-advanced-color-picker v-model="$themes.primary" class="my-1" />
      </va-dropdown>

      <va-dropdown class="color-picker-dropdown mt-1 mb-1">
        <va-badge
          slot="anchor"
          class="color-picker-dropdown__badge"
          color="secondary"
        >
          Secondary
        </va-badge>
        <va-advanced-color-picker v-model="$themes.secondary" class="my-1" />
      </va-dropdown>

      <va-dropdown class="color-picker-dropdown mt-1 mb-1">
        <va-badge
          slot="anchor"
          class="color-picker-dropdown__badge"
          color="success"
        >
          Success
        </va-badge>
        <va-advanced-color-picker v-model="$themes.success" class="my-1" />
      </va-dropdown>

      <va-dropdown class="color-picker-dropdown mt-1 mb-1">
        <va-badge
          slot="anchor"
          class="color-picker-dropdown__badge"
          color="info"
        >
          Info
        </va-badge>
        <va-advanced-color-picker v-model="$themes.info" class="my-1" />
      </va-dropdown>

      <va-dropdown class="color-picker-dropdown mt-1 mb-1">
        <va-badge
          slot="anchor"
          class="color-picker-dropdown__badge"
          color="danger"
        >
          Danger
        </va-badge>
        <va-advanced-color-picker v-model="$themes.danger" class="my-1" />
      </va-dropdown>

      <va-dropdown class="color-picker-dropdown mt-1 mb-1">
        <va-badge
          slot="anchor"
          class="color-picker-dropdown__badge"
          color="warning"
        >
          Warning
        </va-badge>
        <va-advanced-color-picker v-model="$themes.warning" class="my-1" />
      </va-dropdown>

      <va-dropdown class="color-picker-dropdown mt-1 mb-1">
        <va-badge
          slot="anchor"
          class="color-picker-dropdown__badge"
          color="gray"
        >
          Gray
        </va-badge>
        <va-advanced-color-picker v-model="$themes.gray" class="my-1" />
      </va-dropdown>

      <va-dropdown class="color-picker-dropdown mt-1 mb-1">
        <va-badge
          slot="anchor"
          class="color-picker-dropdown__badge"
          color="dark"
        >
          Dark
        </va-badge>
        <va-advanced-color-picker v-model="$themes.dark" class="my-1" />
      </va-dropdown>
    </div>
  </va-dropdown>
</template>

<script>
import VaIconColor from '../../../../../iconset/VaIconColor'

export default {
  inject: ['contextConfig'],
  components: {
    VaIconColor,
  },
  computed: {
    selectedTheme: {
      get() {
        return this.contextConfig.invertedColor ? 'corporate' : 'original'
      },
      set(themeName) {
        this.$root.$emit('change-theme', themeName)
      },
    },
    modeOptions() {
      return [
        {
          label: 'Original',
          value: 'original',
        },
        {
          label: 'Corporate',
          value: 'corporate',
        },
      ]
    },
  },
}
</script>

<style lang="scss">
.color-dropdown {
  cursor: pointer;

  &__icon {
    position: relative;
    display: flex;
    align-items: center;
  }

  &__content {
    background-color: $dropdown-background;
    box-shadow: $gray-box-shadow;
    border-radius: 0.5rem;

    .color-picker-dropdown {
      display: flex;
      justify-content: center;

      &__badge {
        /* Badges have 0.5rem to the right by default */
        margin-left: 0.5rem;
      }
    }
  }

  .va-dropdown__anchor {
    display: inline-block;
  }
}

.button-restore {
  display: flex;
  margin: 0.375rem auto;
}
</style>
