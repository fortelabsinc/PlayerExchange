<template>
  <div id="app" class="app">
    <router-view />
  </div>
</template>

<script>
export default {
  name: 'App',
  data() {
    return {
      contextConfig: {
        gradient: false,
        shadow: 'sm', // 3 states: 'sm', 'lg', undefined (no shadow).
        invertedColor: true,
      },
    }
  },
  provide() {
    return {
      contextConfig: this.contextConfig,
    }
  },
  watch: {
    'contextConfig.invertedColor'(val) {
      const invertedColorClass = 'va-inverted-color'
      if (val) {
        document.body.classList.add(invertedColorClass)
      } else {
        document.body.classList.remove(invertedColorClass)
      }
    },
  },
}
</script>

<style lang="scss">
@import '../sass/main.scss';

body {
  height: 100%;

  #app {
    height: 100%;
  }
}
</style>
