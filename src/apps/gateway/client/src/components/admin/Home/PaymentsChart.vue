<template>
  <LineChart class="chart" :chart-data="chartdata" :options="options" />
</template>

<script>
import LineChart from '@/components/common/LineChart'

export default {
  name: 'PaymentsChart',
  components: {
    LineChart,
  },
  data() {
    return {
      chartdata: {
        labels: this.generateLabels(6),
        datasets: [
          {
            label: 'Ripple',
            backgroundColor: 'rgba(99, 255, 132, 0.25)',
            data: this.generateArray(6),
          },
          {
            label: 'Ethereum',
            backgroundColor: 'rgba(54, 162, 235, 0.5)',
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
        //'July',
        //'August',
        //'September',
        //'October',
        //'November',
        //'December',
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
