<template>
  <DoughnutChart class="chart" :chart-data="chartdata" :options="options" />
</template>

<script>
import DoughnutChart from '@/components/common/DoughnutChart'

export default {
  name: 'GuildsChart',
  components: {
    DoughnutChart,
  },
  data() {
    return {
      chartdata: {
        labels: this.generateLabels(6),
        datasets: [
          {
            backgroundColor: [
              'rgba(99, 255, 132, 0.75)',
              'rgba(99, 172, 245, 0.75)',
              'rgba(249, 55, 132, 0.75)',
              'rgba(149, 149, 212, 0.75)',
              'rgba(249, 155, 132, 0.75)',
              'rgba(149, 49, 112, 0.75)',
            ],
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
    generateLabels() {
      return [
        'Looter Shooter',
        'Goats',
        'Tale of Dragons',
        'Double Dribble',
        'Heroes of Destiny',
        'Morty',
      ]
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
