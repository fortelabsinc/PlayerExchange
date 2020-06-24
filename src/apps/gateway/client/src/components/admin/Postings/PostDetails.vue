<template>
  <v-dialog v-model="content">
    <v-card>
      <v-card-title>
        Post Details
      </v-card-title>
      <v-divider class="mb-2" />
      <v-card-text>
        <v-row>
          <v-col class="xs12 lg6">
            <v-text-field
              v-model="posting.post_id"
              name="post_id"
              label="post_id"
              type="text"
              readonly
            />

            <v-text-field
              v-model="posting.user_id"
              name="user_id"
              label="user_id"
              type="text"
              readonly
            />

            <v-row>
              <v-col class="sm12 md6 lg6">
                <v-text-field
                  v-model="posting.game_id"
                  name="game_id"
                  label="game_id"
                  type="text"
                  readonly
                />
              </v-col>

              <v-col class="xs12 md6 lg6">
                <template v-if="posting.state === 'closed'">
                  <v-chip class="ma-2">closed</v-chip>
                </template>
                <template v-else>
                  <v-chip class="ma-2" dark color="green">open</v-chip>
                </template>
              </v-col>
            </v-row>

            <v-row>
              <v-col class="xs12 md6 lg6">
                <v-text-field
                  v-model="posting.user_count_req"
                  name="user_count_req"
                  label="user_count_req"
                  type="text"
                  readonly
                />
              </v-col>

              <v-col class="xs12 md6 lg6">
                <v-text-field
                  v-model="posting.type_req"
                  name="type_req"
                  label="type_req"
                  type="text"
                  readonly
                />
              </v-col>
            </v-row>
            <v-text-field
              v-model="posting.details"
              name="details"
              label="details"
              type="text"
              readonly
            />
          </v-col>
          <v-col class="xs12 lg6">
            <v-row>
              <v-col class="xs12 md6 lg6">
                <v-text-field
                  v-model="posting.confirm_pay_amt"
                  name="confirm_pay_amt"
                  label="confirm_pay_amt"
                  type="text"
                  readonly
                />
                <v-text-field
                  v-model="posting.complete_pay_amt"
                  name="complete_pay_amt"
                  label="complete_pay_amt"
                  type="text"
                  readonly
                />
                <v-text-field
                  v-model="posting.bonus_pay_amt"
                  name="bonus_pay_amt"
                  label="bonus_pay_amt"
                  type="text"
                  readonly
                />
              </v-col>
              <v-col class="xs12 md6 lg6">
                <v-text-field
                  v-model="posting.confirm_pay_type"
                  name="confirm_pay_type"
                  label="confirm_pay_type"
                  type="text"
                  readonly
                />
                <v-text-field
                  v-model="posting.complete_pay_type"
                  name="complete_pay_type"
                  label="complete_pay_type"
                  type="text"
                  readonly
                />
                <v-text-field
                  v-model="posting.bonus_pay_type"
                  name="bonus_pay_type"
                  label="bonus_pay_type"
                  type="text"
                  readonly
                />
              </v-col>
            </v-row>
            <v-row>
              <v-col class="xs12 lg12">
                <v-textarea
                  v-model="posting.bonus_req"
                  name="bonus_req"
                  label="bonus_req"
                  type="text"
                  auto-grow
                  readonly
                />
              </v-col>
            </v-row>
          </v-col>
        </v-row>
      </v-card-text>
      <v-card-actions>
        <v-spacer />
        <v-btn color="primary" text @click="close">
          Close
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
export default {
  name: 'PostDetails',
  props: ['value', 'posting'],
  data() {
    return {
      content: this.value,
    }
  },
  watch: {
    value(val) {
      this.content = val
    },
    content(val) {
      this.$emit('input', val)
    },
  },
  methods: {
    close() {
      this.content = false
    },
  },
}
</script>

<style lang="scss"></style>
