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
            </div>
            <!--
            <div class="row">
              <div class="flex md4 sm6 xs12">
                <va-input
                  v-model="simple"
                  placeholder="Text Input"
                />
              </div>
              <div class="flex md4 sm6 xs12">
                <va-input
                  v-model="withIcon"
                  placeholder="Input With Icon"
                >
                  <va-icon
                    slot="prepend"
                    color="gray"
                    name="fa fa-envelope-o"
                  />
                </va-input>
              </div>
              <div class="flex md4 sm6 xs12">
                <va-input
                  v-model="withButton"
                  placeholder="Input With Button"
                >
                  <va-button slot="append" style="margin-right: 0;" small>
                    UPLOAD
                  </va-button>
                </va-input>
              </div>
              <div class="flex md4 sm6 xs12">
                <va-input
                  v-model="successfulEmail"
                  type="email"
                  label="Email (Validated with success)"
                  success>
                </va-input>
              </div>
              <div class="flex md4 sm6 xs12">
                <va-input
                  v-model="clearableText"
                  placeholder="Input With Clear Button"
                  removable
                />
              </div>
              <div class="flex md4 sm6 xs12">
                <va-input
                  v-model="wrongEmail"
                  type="email"
                  label="Email (Validated)"
                  error
                  :error-messages="errorMessages">
                </va-input>
              </div>
              <div class="flex md4 sm6 xs12">
                <va-input
                  v-model="withDescription"
                  placeholder="Text Input (with description)"
                  :messages="messages"
                />
              </div>
            </div>
            -->
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
      games:[],
      currencies: []
    }
  },
  mounted() {
    this.games = store.getters.games
    this.currencies = store.getters.currencies
    
  },
  watch: {
  },
  methods: {
    gameOptions() {
      return store.getters.games;
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
