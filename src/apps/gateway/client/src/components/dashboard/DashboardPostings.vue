<template>
  <div class="row row-equal">
    <div class="flex xs12">
      <va-card :title="$t('postings.forms.create.title')">
        <form>
          <div class="row">
            <div class="flex md4 sm6 xs12">
              <va-select
                v-model="game"
                :label="$t('postings.forms.create.game_select')"
                text-by="description"
                :options="games"
              />
            </div>
            <div class="flex md4 sm6 xs12">
              <va-input
                v-model="player_count"
                :label="$t('postings.forms.create.player_count')"
                text-by="The number of player needed"
              />
            </div>
            <div class="flex md4 sm6 xs12">
              <va-select
                v-model="type"
                :label="$t('postings.forms.create.player_type')"
                text-by="Type of Players"
                :options="types"
              />
            </div>
          </div>
          <div class="row">
            <div class="flex xs12">
              <va-input
                v-model="description"
                :label="$t('postings.forms.create.description')"
                text-by="Description of work"
              />
            </div>
          </div>
          <div class="row">
            <div class="flex xs6 xs2">
              <va-input
                v-model="confirm_amt"
                :label="$t('postings.forms.create.confirm_amount')"
                placeholder="Text Input"
              />
            </div>
            <div class="flex xs6 xs2">
              <va-select
                v-model="confirm_type"
                :label="$t('postings.forms.create.confirm_type')"
                text-by="Payout Type"
                :options="currencies"
              />
            </div>
          </div>
          <div class="row">
            <div class="flex xs6 xs2">
              <va-input
                v-model="complete_amt"
                :label="$t('postings.forms.create.complete_amount')"
                placeholder="Text Input"
              />
            </div>
            <div class="flex xs6 xs2">
              <va-select
                v-model="complete_type"
                :label="$t('postings.forms.create.complete_amount')"
                text-by="Payout Type"
                :options="currencies"
              />
            </div>
          </div>
          <div class="row">
            <div class="flex xs6 xs2">
              <va-input
                v-model="bonus_amt"
                :label="$t('postings.forms.create.bonus_amount')"
                placeholder="Text Input"
              />
            </div>
            <div class="flex xs6 xs2">
              <va-select
                v-model="bonus_type"
                :label="$t('postings.forms.create.bonus_amount')"
                text-by="Payout Type"
                :options="currencies"
              />
            </div>
          </div>
          <div class="row">
            <div class="flex xs4 md9">
              <va-input
                v-model="bonus_req"
                :label="$t('postings.forms.create.bonus_req')"
                text-by="Description of bonus"
              />
            </div>
            <div class="flex xs8 md3">
              <va-button @click="submit">
                {{ $t('postings.forms.create.button_submit') }}
              </va-button>
            </div>
          </div>
        </form>
      </va-card>
    </div>
    <va-modal
      v-model="showModal"
      size="small"
      :title="$t('postings.forms.create.submit_title')"
      cancel-class="none"
      :message="$t('postings.forms.create.submit_message')"
      :ok-text="$t('postings.forms.create.submit_confirm')"
      no-outside-dismiss
      no-esc-dismiss
    />
  </div>
</template>

<script>
import store from '@/store'
import Network from '../../network'

export default {
  name: 'DashboardPostings',
  data() {
    return {
      game: '',
      player_count: 1,
      type: 'Individual',
      currency: 'XRP',
      confirm_amt: 1,
      confirm_type: 'XRP',
      complete_amt: 1,
      complete_type: 'XRP',
      bonus_amt: 1,
      bonus_type: 'XRP',
      bonus_req: '',
      description: '',
      showModal: false,

      games: [],
      currencies: [],
      types: [],
    }
  },
  computed: {},
  watch: {},
  mounted() {
    this.games = store.getters.games
    this.currencies = store.getters.currencies
    this.types = ['Individual', 'Guild']
  },
  methods: {
    gameOptions() {
      return store.getters.games
    },
    submit(event) {
      this.showModal = true
      var data = {
        meta: {},
        game_id: this.game,
        details: this.description,
        conf_type: this.confirm_type,
        conf_amt: String(this.confirm_amt),
        comp_type: this.complete_type,
        comp_amt: String(this.complete_amt),
        bonus_type: this.bonus_type,
        bonus_amt: String(this.bonus_amt),
        bonus_req: this.bonus_req,
        user_count: Number(this.player_count),
        type: this.type,
      }
      Network.work.createPosting(data, (success, data) => {
        if (success) {
          this.$eventHub.$emit('refresh-postings')
          //this.game = '';
          //this.player_count = 1;
          //this.type = "Individual";
          //this.currency = "XRP";
          //this.confirm_amt = 1;
          //this.confirm_type = "XRP";
          //this.complete_amt = 1;
          //this.complete_type = "XRP";
          //this.bonus_amt = 1;
          //this.bonus_type = "XRP";
          //this.bonus_req = "";
          //this.description = "";
          //this.description = "";
        } else {
        }
      })
    },
  },
}
</script>

<style scoped>
.chart {
  height: 400px;
}
</style>
