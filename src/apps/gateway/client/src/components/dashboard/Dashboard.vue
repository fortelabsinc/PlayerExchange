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
}
</script>
