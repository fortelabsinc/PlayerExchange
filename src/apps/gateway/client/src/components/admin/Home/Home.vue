<template>
  <div>
    <v-row no-gutters>
      <v-col class="mr-3">
        <AppLayoutPanel>
          <v-toolbar flat color="white">
            <v-toolbar-title>Games</v-toolbar-title>
          </v-toolbar>
          <GamesChart />
        </AppLayoutPanel>
      </v-col>
      <v-col>
        <AppLayoutPanel>
          <v-toolbar flat color="white">
            <v-toolbar-title>Guilds</v-toolbar-title>
          </v-toolbar>
          <GuildsChart />
        </AppLayoutPanel>
      </v-col>
    </v-row>
    <v-row>
      <v-col>
        <AppLayoutPanel>
          <v-toolbar flat color="white">
            <v-toolbar-title>Payments</v-toolbar-title>
          </v-toolbar>
          <PaymentsChart />
        </AppLayoutPanel>
      </v-col>
    </v-row>
  </div>
</template>

<script>
import AppLayoutPanel from '@/components/admin/AppLayoutPanel.vue'
import GamesChart from './GamesChart'
import GuildsChart from './GuildsChart'
import PaymentsChart from './PaymentsChart'

export default {
  name: 'Home',
  components: {
    AppLayoutPanel,
    GamesChart,
    GuildsChart,
    PaymentsChart,
  },
}
</script>
