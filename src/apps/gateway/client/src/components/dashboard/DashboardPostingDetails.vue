<template>
  <div class="row">
    <div class="flex xs12 lg6">
      <va-item>
        <va-item-section>
          <va-item-label caption>
            {{ $t('postingDetails.modal.post_id') }}
          </va-item-label>

          <va-item-label>
            {{ posting.post_id }}
          </va-item-label>
        </va-item-section>
      </va-item>

      <va-item >
        <va-item-section>
          <va-item-label caption>
            {{ $t('postingDetails.modal.user_id') }}
          </va-item-label>

          <va-item-label>
            {{ posting.user_id }}
          </va-item-label>
        </va-item-section>
      </va-item>

      <div class="row">
        <div class="flex 12 md6 lg6">
          <va-item >
            <va-item-section>
              <va-item-label caption>
                {{ $t('postingDetails.modal.game_id') }}
              </va-item-label>

              <va-item-label>
                {{ posting.game_id }}
              </va-item-label>
            </va-item-section>
          </va-item>
        </div>

        <div class="flex xs12 md6 lg6">
          <va-item >
            <va-item-section>
              <va-item-label caption>
                {{ $t('postingDetails.modal.state') }}
              </va-item-label>

              <va-item-label>
                <template v-if="posting.state === 'closed'">
                  <va-badge class="mb-2" color="danger">closed</va-badge>
                </template>
                <template v-else>
                  <va-badge class="mb-2" color="success">open</va-badge>
                </template>
              </va-item-label>
            </va-item-section>
          </va-item>
        </div>
      </div>

      <div class="row">
        <div class="flex xs12 md6 lg6">
          <va-item >
            <va-item-section>
              <va-item-label caption>
                {{ $t('postingDetails.modal.user_count_req') }}
              </va-item-label>

              <va-item-label>
                {{ posting.user_count_req }}
              </va-item-label>
            </va-item-section>
          </va-item>
        </div>

        <div class="flex xs12 md6 lg6">
          <va-item >
            <va-item-section>
              <va-item-label caption>
                {{ $t('postingDetails.modal.type_req') }}
              </va-item-label>

              <va-item-label>
                {{ posting.type_req }}
              </va-item-label>
            </va-item-section>
          </va-item>
        </div>
      </div>

      <va-item >
        <va-item-section>
          <va-item-label caption>
            {{ $t('postingDetails.modal.details') }}
          </va-item-label>

          <va-item-label :style="{whiteSpace: 'pre-wrap'}">
            {{ posting.details }}
          </va-item-label>
        </va-item-section>
      </va-item>
    </div>
    <div class="flex xs12 lg6">
      <div class="row">
        <div class="flex xs12 md6 lg6">
          <va-item >
            <va-item-section>
              <va-item-label caption>
                {{ $t('postingDetails.modal.confirm_pay_amt') }}
              </va-item-label>

              <va-item-label>
                {{ posting.confirm_pay_amt || 0 }}
              </va-item-label>
            </va-item-section>
          </va-item>

          <va-item >
            <va-item-section>
              <va-item-label caption>
                {{ $t('postingDetails.modal.complete_pay_amt') }}
              </va-item-label>

              <va-item-label>
                {{ posting.complete_pay_amt || 0 }}
              </va-item-label>
            </va-item-section>
          </va-item>

          <va-item >
            <va-item-section>
              <va-item-label caption>
                {{ $t('postingDetails.modal.bonus_pay_amt') }}
              </va-item-label>

              <va-item-label>
                {{ posting.bonus_pay_amt || 0 }}
              </va-item-label>
            </va-item-section>
          </va-item>
        </div>
        <div class="flex xs12 md6 lg6">
          <va-item >
            <va-item-section>
              <va-item-label caption>
                {{ $t('postingDetails.modal.confirm_pay_type') }}
              </va-item-label>

              <va-item-label>
                {{ posting.confirm_pay_type || '-' }}
              </va-item-label>
            </va-item-section>
          </va-item>

          <va-item >
            <va-item-section>
              <va-item-label caption>
                {{ $t('postingDetails.modal.complete_pay_type') }}
              </va-item-label>

              <va-item-label>
                {{ posting.complete_pay_type || '-' }}
              </va-item-label>
            </va-item-section>
          </va-item>

          <va-item >
            <va-item-section>
              <va-item-label caption>
                {{ $t('postingDetails.modal.bonus_pay_type') }}
              </va-item-label>

              <va-item-label>
                {{ posting.bonus_pay_type || '-' }}
              </va-item-label>
            </va-item-section>
          </va-item>
        </div>
      </div>
      <div class="row">
        <div class="flex xs12 lg12">
          <va-item >
            <va-item-section>
              <va-item-label caption>
                {{ $t('postingDetails.modal.bonus_req') }}
              </va-item-label>

              <va-item-label :style="{whiteSpace: 'pre-wrap'}">
                {{ posting.bonus_req }}
              </va-item-label>
            </va-item-section>
          </va-item>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'dashboard-posting-details',
  props: ['posting'],
}
</script>

<style lang="scss">
</style>
