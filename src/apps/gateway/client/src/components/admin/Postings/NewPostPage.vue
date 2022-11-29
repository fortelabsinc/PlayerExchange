<template>
  <AppLayoutPanel>
    <v-form ref="form" v-model="valid" lazy-validation>
      <v-row>
        <v-col>
          <v-select
            v-model="game"
            label="Game"
            :items="games"
            item-text="name"
            item-value="game_id"
            required
          />
        </v-col>
        <v-col>
          <v-text-field
            v-model="player_count"
            type="text"
            name="player_count"
            label="Number of Players"
            required
          />
        </v-col>
        <v-col>
          <v-select
            v-model="type"
            name="type"
            :items="types"
            label="Player Type"
            required
          />
        </v-col>
      </v-row>

      <v-textarea
        v-model="description"
        type="text"
        name="description"
        label="Describe what you need help with"
        auto-grow
        required
      />

      <v-row>
        <v-col>
          <v-text-field
            v-model="confirm_amt"
            type="text"
            name="confirm_amt"
            label="Amount to pay on confirmation"
            required
          />
        </v-col>
        <v-col>
          <v-select
            v-model="confirm_type"
            name="confirm_type"
            :items="currencies"
            label="Currency Payout Type"
            required
          />
        </v-col>
      </v-row>

      <v-row>
        <v-col>
          <v-text-field
            v-model="complete_amt"
            type="text"
            name="complete_amt"
            label="Amount to pay on completion"
            required
          />
        </v-col>
        <v-col>
          <v-select
            v-model="complete_type"
            name="complete_type"
            :items="currencies"
            label="Currency Payout for Completion"
            required
          />
        </v-col>
      </v-row>

      <v-row>
        <v-col>
          <v-text-field
            v-model="bonus_amt"
            type="text"
            name="bonus_amt"
            label="Amount to pay for bonus"
            required
          />
        </v-col>
        <v-col>
          <v-select
            v-model="bonus_type"
            name="bonus_type"
            :items="currencies"
            label="Currency Payout for Bonus"
            required
          />
        </v-col>
      </v-row>

      <v-textarea
        v-model="bonus_req"
        type="text"
        name="bonus_req"
        label="Describe what will trigger the bonus payout"
        auto-grow
        required
      />
    </v-form>

    <v-card-actions>
      <v-progress-linear
        v-if="creating"
        :active="true"
        :indeterminate="true"
        color="primary"
      />
      <template v-else>
        <v-spacer />
        <v-btn depressed small class="mr-2" @click="cancelNewPost">
          Cancel
        </v-btn>
        <v-btn color="primary" depressed small @click="onSubmit">
          Post Work
        </v-btn>
      </template>
    </v-card-actions>
  </AppLayoutPanel>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import AppLayoutPanel from '@/components/admin/AppLayoutPanel.vue'

export default {
  name: 'NewPostPage',
  components: {
    AppLayoutPanel,
  },
  data() {
    return {
      games: [],
      game: '',
      player_count: '',
      type: '',
      description: '',
      confirm_amt: '',
      confirm_type: '',
      complete_amt: '',
      complete_type: '',
      bonus_amt: '',
      bonus_type: '',
      bonus_req: '',
      valid: true,
      rules: {
        name: [(v) => v.length >= 4 || 'Min 4 characters'],
      },
      creating: false,
    }
  },
  computed: {
    ...mapGetters({
      currencies: 'options/getCurrencies',
      types: 'options/getTypes',
    }),
  },
  mounted() {
    this.fetchAppNames()
  },
  methods: {
    ...mapActions({
      apiCreatePost: 'work/ApiActionCreatePosting',
      getAllAppNames: 'apps/ApiActionFetchAllAppNames',
    }),
    fetchAppNames() {
      this.getAllAppNames().then(({ payload, error }) => {
        if (payload) {
          var result = Object.keys(payload).map(function(key) {
            return { game_id: key, name: payload[key] }
          })
          this.games = result
        }
        if (error) {
          this.$toast.error(`Error fetching apps. ${error.message}`)
        }
      })
    },
    cancelNewPost() {
      this.$router.push({ name: 'My Postings' })
    },
    onSubmit() {
      if (!this.$refs.form.validate()) {
        return
      }
      this.showModal = true

      this.creating = true

      let args = {
        meta: {},
        game_id: this.game,
        user_count: Number(this.player_count),
        type: this.type,
        details: this.description,
        conf_amt: String(this.confirm_amt),
        conf_type: this.confirm_type,
        comp_amt: String(this.complete_amt),
        comp_type: this.complete_type,
        bonus_amt: String(this.bonus_amt),
        bonus_type: this.bonus_type,
        bonus_req: this.bonus_req,
      }

      this.apiCreatePost(args).then(({ error }) => {
        this.creating = false
        if (!error) {
          this.$router.push({ name: 'My Postings' })
          this.$toast.success('Post created successfully.')
        } else {
          this.$toast.error(`Error creating the post. ${error.message}`)
        }
      })
    },
  },
}
</script>
