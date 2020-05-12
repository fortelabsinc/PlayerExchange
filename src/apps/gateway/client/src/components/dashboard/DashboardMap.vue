<template>
  <va-card :title="$t('dashboard.currentVisitors')">
    <line-map class="dashboard-map" :map-data="lineMapData" />
  </va-card>
</template>

<script>
import LineMap from '../../components/maps/line-maps/LineMap'
import { getLineMapData } from '../../data/maps/LineMapData'

export default {
  name: 'DashboardMap',
  components: {
    LineMap,
  },
  data() {
    return {
      lineMapData: { cities: [], mainCity: '' },
    }
  },
  watch: {
    '$themesOptions.activeThemeName': {
      // hack for trigger change themes
      handler() {
        this.lineMapData = getLineMapData(this.$themes)
      },
      immediate: true,
    },
  },
  mounted() {
    this.lineMapData = getLineMapData(this.$themes)
  },
  methods: {
    addAddress(address) {
      this.lineMapData = {
        ...this.lineMapData,
        cities: this.lineMapData.cities.map((city) => ({
          ...city,
          color:
            city.title === address.city ? this.$themes.success : city.color,
        })),
      }
    },
  },
}
</script>

<style>
.dashboard-map {
  height: 380px;
}
</style>
