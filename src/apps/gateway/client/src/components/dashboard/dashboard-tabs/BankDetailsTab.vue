<template>
  <div class="pt-2">
    <div class="title text-dark mb-1" :style="{ color: $themes.primary }">
      {{ $t('dashboard.tabs.bankDetails.detailsFields') }}
    </div>
    <div class="row">
      <div class="flex xs12 md6">
        <va-input
          v-model="form.bankName"
          :label="$t('dashboard.tabs.bankDetails.bankName')"
        />
        <va-input
          v-model="form.accountName"
          :label="$t('dashboard.tabs.bankDetails.accountName')"
        />
        <va-input
          v-model="form.sortCode"
          :label="$t('dashboard.tabs.bankDetails.sortCode')"
        />
      </div>
      <div class="flex xs12 md6">
        <va-input
          v-model="form.accountNumber"
          :label="$t('dashboard.tabs.bankDetails.accountNumber')"
        />
        <va-input
          v-model="form.notes"
          :label="$t('dashboard.tabs.bankDetails.notes')"
        />
      </div>
    </div>
    <div class="row justify--center">
      <va-button @click="sendDetails">
        {{ $t('dashboard.tabs.bankDetails.sendDetails') }}
      </va-button>
    </div>
  </div>
</template>

<script>
export default {
  name: 'BankDetailsTab',
  data() {
    return {
      form: {
        bankName: 'Raiffeisen Bank',
        accountName: 'GoalSaver',
        sortCode: '6558912',
        accountNumber: '000876432',
        notes: '',
      },
    }
  },
  methods: {
    sendDetails() {
      this.showToast('Saved!')
    },
  },
}
</script>
