<template>
  <div class="row row-equal">
      <div class="flex xs12">
        <va-card :title="$t('postings.forms.create.title')">
          <form>
            <div class="row">
              <div class="flex md4 sm6 xs12">
                <va-select
                  :label="$t('postings.forms.create.game_select')"
                  v-model="game"
                  textBy="description"
                  :options="games"
                />
              </div>
              <div class="flex md4 sm6 xs12">
                <va-input
                  :label="$t('postings.forms.create.player_count')"
                  v-model="player_count"
                  textBy="The number of player needed"
                />
              </div>
              <div class="flex md4 sm6 xs12">
                <va-select
                  :label="$t('postings.forms.create.player_type')"
                  v-model="type"
                  textBy="Type of Players"
                  :options="types"
                />
              </div>
            </div>
            <div class="row">
              <div class="flex xs12">
                <va-input
                  :label="$t('postings.forms.create.description')"
                  v-model="description"
                  textBy="Description of work"
                />
              </div>
            </div>
            <div class="row">
              <div class="flex xs6 xs2">
                <va-input
                  :label="$t('postings.forms.create.confirm_amount')"
                  v-model="confirm_amt"
                  placeholder="Text Input"
                />
              </div>
              <div class="flex xs6 xs2">
                <va-select
                  :label="$t('postings.forms.create.confirm_type')"
                  v-model="confirm_type"
                  textBy="Payout Type"
                  :options="currencies"
                />
              </div>
            </div>
            <div class="row">
              <div class="flex xs6 xs2">
                <va-input
                  :label="$t('postings.forms.create.complete_amount')"
                  v-model="complete_amt"
                  placeholder="Text Input"
                />
              </div>
              <div class="flex xs6 xs2">
                <va-select
                  :label="$t('postings.forms.create.complete_amount')"
                  v-model="complete_type"
                  textBy="Payout Type"
                  :options="currencies"
                />
              </div>
            </div>
            <div class="row">
              <div class="flex xs6 xs2">
                <va-input
                  :label="$t('postings.forms.create.bonus_amount')"
                  v-model="bonus_amt"
                  placeholder="Text Input"
                />
              </div>
              <div class="flex xs6 xs2">
                <va-select
                  :label="$t('postings.forms.create.bonus_amount')"
                  v-model="bonus_type"
                  textBy="Payout Type"
                  :options="currencies"
                />
              </div>
            </div>
            <div class="row">
              <div class="flex xs4 md9">
                <va-input
                  :label="$t('postings.forms.create.bonus_req')"
                  v-model="bonus_req"
                  textBy="Description of bonus"
                />
              </div>
              <div class="flex xs8 md3">
                <va-button v-on:click="submit">
                  {{$t('postings.forms.create.button_submit') }}
                </va-button> 
              </div>
            </div>
          </form>
        </va-card>
      </div>
  </div>
</template>

<script>
import { getDonutChartData } from '../../data/charts/DonutChartData'
import { getLineChartData } from '../../data/charts/LineChartData'
import DashboardContributorsChart from './DashboardContributorsList'
import store from '@/store';

export default {
  name: 'dashboard-postings',
  components: { DashboardContributorsChart },
  data () {
    return {
      game: '',
      player_count: 1,
      type: "Individual",
      currency: "XRP",
      confirm_amt: 1,
      confirm_type: "XRP",
      complete_amt: 1,
      complete_type: "XRP",
      bonus_amt: 1,
      bonus_type: "XRP",
      bonus_req: "",
      description: "",

      games:[],
      currencies: [],
      types: []

    }
  },
  mounted() {
    this.games = store.getters.games;
    this.currencies = store.getters.currencies;
    this.types = ["Individual", "Guild"] ;
  },
  watch: {
  },
  methods: {
    gameOptions() {
      return store.getters.games;
    },
    submit(event){
      console.log("woot");
    }
  },
  computed: {
  },
}
</script>

<style scoped>
  .chart {
    height: 400px;
  }
</style>
