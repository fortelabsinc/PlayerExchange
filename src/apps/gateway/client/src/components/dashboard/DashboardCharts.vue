<template>
  <div class="row row-equal">
    <div class="flex xs12 xl6">
      <va-card :title="$t('dashboard.charts.trendyTrends')">
        <va-button
          slot="actions"
          small
          color="danger"
          class="mr-0"
          :disabled="lineChartData.labels.length < 2"
          @click="deleteSection"
        >
          {{ $t('dashboard.charts.showInMoreDetail') }}
        </va-button>
        <va-chart
          ref="lineChart"
          class="chart"
          :data="lineChartData"
          type="line"
        />
      </va-card>
    </div>

    <div class="flex xs12 md6 xl3">
      <va-card :title="$t('dashboard.charts.loadingSpeed')">
        <va-button
          slot="actions"
          icon="fa fa-print"
          flat
          class="mr-0"
          @click="printChart"
        />
        <va-chart
          class="chart chart--donut"
          :data="donutChartData"
          type="donut"
        />
      </va-card>
    </div>

    <div class="flex xs12 md6 xl3">
      <dashboard-contributors-chart />
    </div>
  </div>
</template>

<script>
import { getDonutChartData } from '../../data/charts/DonutChartData'
import { getLineChartData } from '../../data/charts/LineChartData'
import DashboardContributorsChart from './DashboardContributorsList'

export default {
  name: 'DashboardCharts',
  components: { DashboardContributorsChart },
  data() {
    return {
      lineChartData: getLineChartData(this.$themes),
      donutChartData: getDonutChartData(this.$themes),
      lineChartFirstMonthIndex: 0,
    }
  },
  computed: {
    donutChartDataURL() {
      return document
        .querySelector('.chart--donut canvas')
        .toDataURL('image/png')
    },
  },
  watch: {
    '$themes.primary'() {
      this.lineChartData = getLineChartData(this.$themes)
      this.donutChartData = getDonutChartData(this.$themes)
    },

    '$themes.info'() {
      this.lineChartData = getLineChartData(this.$themes)
      this.donutChartData = getDonutChartData(this.$themes)
    },

    '$themes.danger'() {
      this.donutChartData = getDonutChartData(this.$themes)
    },
  },
  methods: {
    deleteSection() {
      this.lineChartFirstMonthIndex += 1
      this.lineChartData = getLineChartData(
        this.$themes,
        this.lineChartFirstMonthIndex
      )
      this.$refs.lineChart.$refs.chart.refresh()
    },
    printChart() {
      const win = window.open('', 'Print', 'height=600,width=800')
      win.document.write(`<br><img src='${this.donutChartDataURL}'/>`)
      // TODO: find better solution how to remove timeout
      setTimeout(() => {
        win.document.close()
        win.focus()
        win.print()
        win.close()
      }, 200)
    },
  },
}
</script>

<style scoped>
.chart {
  height: 400px;
}
</style>
