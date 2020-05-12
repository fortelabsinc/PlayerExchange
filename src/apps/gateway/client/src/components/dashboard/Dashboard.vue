<template>
  <div class="dashboard">
    <dashboard-all-postings-table />
    <dashboard-postings />
    <dashboard-my-postings-table />
    <dashboard-payment />
  </div>
</template>

<script>
import DashboardPostings from './DashboardPostings'
import DashboardMyPostingsTable from './DashboardMyPostingsTable'
import DashboardAllPostingsTable from './DashboardAllPostingsTable'
import DashboardPayment from './DashboardPayment'

export default {
  name: 'Dashboard',
  components: {
    DashboardPostings,
    DashboardMyPostingsTable,
    DashboardAllPostingsTable,
    DashboardPayment,
  },
  methods: {
    addAddressToMap({ city, country }) {
      this.$refs.dashboardMap.addAddress({ city: city.text, country })
    },
  },
}
</script>

<style lang="scss">
.row-equal .flex {
  .va-card {
    height: 100%;
  }
}

.dashboard {
  .va-card {
    margin-bottom: 0 !important;
  }
}
</style>
