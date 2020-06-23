<template>
  <BarChart class="chart" :chart-data="chartdata" :options="options" />
</template>

<script>
import BarChart from '@/components/common/BarChart'

export default {
  name: 'GamesChart',
  components: {
    BarChart,
  },
  data() {
    return {
      chartdata: {
        labels: this.generateLabels(6),
        datasets: [
          {
            label: 'Activity',
            backgroundColor: 'rgba(99, 172, 245, 0.75)',
            data: this.generateArray(6),
          },
        ],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
      },
    }
  },
  methods: {
    generateLabels(length) {
      const months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ]
      return [...months, ...months].splice(8, length)
    },
    generateArray(length) {
      return Array.from(Array(length), this.generateValue)
    },
    generateValue() {
      return Math.floor(Math.random() * 100)
    },
  },
}
</script>

<style scoped>
.chart {
  height: 300px;
}
</style>
