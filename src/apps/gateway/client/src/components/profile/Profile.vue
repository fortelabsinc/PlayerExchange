<template>
  <div class="lists">
    <div class="row">
      <div class="flex xs12 lg6">
        <va-list fit class="mb-2">
          <va-list-label>
            {{ $t('profile.account.title') }}
          </va-list-label>

          <va-item>
            <va-item-section>
              <va-item-label caption>
                {{ $t('profile.account.username') }}
              </va-item-label>

              <va-item-label>
                {{ username }}
              </va-item-label>
            </va-item-section>
          </va-item>

          <va-item>
            <va-item-section>
              <va-item-label caption>
                {{ $t('profile.account.email') }}
              </va-item-label>

              <va-item-label>
                {{ email }}
              </va-item-label>
            </va-item-section>
          </va-item>

          <va-list-separator fit spaced />

          <va-item>
            <va-item-section>
              <va-item-label caption>
                {{ $t('profile.account.pay_id') }}
              </va-item-label>

              <va-item-label>
                {{ pay_id }}
              </va-item-label>
            </va-item-section>
          </va-item>
        </va-list>
      </div>

      <div class="flex xs12 lg6">
        <va-list fit>
          <va-list-label>
            {{ $t('profile.balance.title') }}
          </va-list-label>

          <va-item v-for="item in balance" :key="item.id" clickable>
            <va-item-section
              side
              :style="{ color: $parent.$themes.primary, fontWeight: 'bold' }"
            >
              {{ item.id }}
            </va-item-section>

            <va-item-section>
              <va-item-label>
                {{ item.balance }}
              </va-item-label>
            </va-item-section>
          </va-item>
        </va-list>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'

export default {
  computed: {
    ...mapGetters({
      username: 'auth/getUserName',
      email: 'auth/getEmail',
      pay_id: 'auth/getPayId',
      balance: 'wallet/getBalances',
    }),
  },
  mounted() {
    this.getBalances({
      callback: (success) => {
        if (!success) {
          console.log('Failed to load balances')
        }
      },
    })
  },
  methods: {
    ...mapActions({
      getBalances: 'wallet/ApiActionFetchBalances',
    }),
  },
}
</script>
