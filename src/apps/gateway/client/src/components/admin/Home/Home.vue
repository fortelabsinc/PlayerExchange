<template>
  <div>
    <v-row>
      <v-col lg="6">
        <v-card>
          <v-toolbar flat color="white">
            <v-toolbar-title>Games</v-toolbar-title>
          </v-toolbar>
          <GamesChart />
        </v-card>
      </v-col>
      <v-col lg="6">
        <v-card>
          <v-toolbar flat color="white">
            <v-toolbar-title>Guilds</v-toolbar-title>
          </v-toolbar>
          <GuildsChart />
        </v-card>
      </v-col>
    </v-row>
    <v-row>
      <v-col>
        <v-card>
          <v-toolbar flat color="white">
            <v-toolbar-title>Payments</v-toolbar-title>
          </v-toolbar>
          <PaymentsChart />
        </v-card>
      </v-col>
    </v-row>
  </div>
</template>

<script>
import GamesChart from './GamesChart'
import GuildsChart from './GuildsChart'
import PaymentsChart from './PaymentsChart'

export default {
  name: 'Home',
  components: {
    GamesChart,
    GuildsChart,
    PaymentsChart,
  },
}
</script>
