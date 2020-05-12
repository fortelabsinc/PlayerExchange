<template>
  <div class="cards">
    <div class="cards-container row d-flex wrap align--start">
      <!-- eslint-disable vue/valid-v-for -->
      <template v-for="loop in listLoops">
        <div :key="loop + '-1'" class="flex xs12 sm6">
          <va-card :title="$t('cards.title.default')">
            {{ $t('cards.contentTextLong') }}
          </va-card>
        </div>

        <div :key="loop + '-2'" class="flex xs12 sm6">
          <va-card :title="$t('cards.title.withControls')">
            <template slot="actions">
              <va-button icon="fa fa-refresh" />
              <va-button icon="fa fa-gear" />
            </template>
            {{ $t('cards.contentTextLong') }}
          </va-card>
        </div>

        <div :key="loop + '-3'" class="flex xs12 sm6">
          <va-card>
            <template slot="header">
              <va-icon name="fa fa-cogs mr-3" color="success" />
              <h5 class="mt-0 mb-0">{{ $t('cards.title.customHeader') }}</h5>
            </template>
            {{ $t('cards.contentTextLong') }}
          </va-card>
        </div>

        <div :key="loop + '-4'" class="flex xs12 sm6">
          <va-card>
            <p>{{ $t('cards.title.withoutHeader') }}</p>
            {{ $t('cards.contentTextLong') }}
          </va-card>
        </div>

        <div :key="loop + '-5'" class="flex xs12 sm6 lg4 xl3">
          <va-card
            image="https://picsum.photos/300/200/?image=1043"
            :title="$t('cards.title.withImage')"
          >
            {{ $t('cards.contentText') }}
          </va-card>
        </div>

        <div :key="loop + '-6'" class="flex xs12 sm6 lg4 xl3">
          <va-card
            overlay
            title-on-image
            image="https://picsum.photos/300/200/?image=898"
            :title="$t('cards.title.withTitleOnImage')"
          >
            {{ $t('cards.contentText') }}
          </va-card>
        </div>

        <div :key="loop + '-7'" class="flex xs12 sm6 lg4 xl3">
          <va-card
            overlay
            title-on-image
            image="https://picsum.photos/300/200/?image=898"
            :title="$t('cards.title.withCustomTitleOnImage')"
          >
            <va-button slot="header" class="ma-0">
              Read More
            </va-button>
          </va-card>
        </div>

        <div :key="loop + '-8'" class="flex xs12 sm6 lg4 xl3">
          <va-card stripe="danger" :title="$t('cards.title.withStripe')">
            {{ $t('cards.contentTextLong') }}
          </va-card>
        </div>

        <div :key="loop + '-9'" class="flex xs12 sm6 lg4 xl3">
          <va-card color="success">
            {{ $t('cards.contentTextLong') }}
          </va-card>
        </div>

        <div :key="loop + '-10'" class="flex xs12 sm6 lg4 xl3">
          <va-card color="danger">
            {{ $t('cards.contentTextLong') }}
          </va-card>
        </div>

        <div :key="loop + '-11'" class="flex xs12 sm6 lg4 xl3">
          <va-card stripe="info" :title="$t('cards.title.withStripe')">
            {{ $t('cards.contentTextLong') }}
          </va-card>
        </div>

        <div :key="loop + '-12'" class="flex xs12 sm6 lg4 xl3">
          <va-card
            overlay
            title-on-image
            image="https://picsum.photos/300/200/?image=1067"
            :title="$t('cards.title.withTitleOnImage')"
          >
            {{ $t('cards.contentText') }}
          </va-card>
        </div>
      </template>
    </div>

    <va-inner-loading class="flex-center py-3" :loading="isLoading">
      <va-button @click="addCards()">
        Show More
      </va-button>
    </va-inner-loading>
  </div>
</template>

<script>
export default {
  name: 'Cards',
  data() {
    return {
      listLoops: 1,
      counter: 1,
      isLoading: false,
    }
  },
  methods: {
    addCards() {
      this.isLoading = true
      setTimeout(() => {
        this.isLoading = false
        ++this.listLoops
      }, 1000)
    },
  },
}
</script>

<style lang="scss">
.cards-container {
  .va-card {
    margin: 0;
  }
}
</style>
