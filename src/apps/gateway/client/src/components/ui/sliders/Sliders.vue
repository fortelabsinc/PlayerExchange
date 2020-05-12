<template>
  <div class="sliders">
    <div class="row">
      <div class="flex md12">
        <va-card :title="$t('sliders.slider')">
          <div class="row">
            <div class="flex xs12 lg6 xl4 mb-2">
              <div class="title mb-3" :style="{ color: this.$themes.primary }">
                {{ $t('sliders.simple') }}
              </div>
              <va-slider v-model="value" />
            </div>
            <div class="flex xs12 lg6 xl4 mb-2">
              <div
                class="title title--danger mb-3"
                :style="{ color: this.$themes.danger }"
              >
                {{ $t('sliders.value') }}
              </div>
              <va-slider v-model="value" color="danger" value-visible />
            </div>
            <div class="flex d-flex align--end xs12 lg6 xl4 mb-2">
              <va-slider
                v-model="value"
                :label="$t('sliders.label')"
                color="info"
                value-visible
              />
            </div>
            <div class="flex d-flex align--end xs12 lg6 xl4 mb-2">
              <va-slider
                v-model="value"
                :label="$t('sliders.label')"
                :invert-label="true"
                color="warning"
                value-visible
              />
            </div>
            <div class="flex xs12 lg6 xl4 mb-2">
              <div class="title mb-3" :style="{ color: this.$themes.primary }">
                {{ $t('sliders.labelPlusIcon') }}
              </div>
              <va-slider v-model="value" icon="fa fa-music" />
            </div>
            <div class="flex xs12 lg6 xl4 mb-2">
              <div
                class="title title--danger mb-3"
                :style="{ color: this.$themes.danger }"
              >
                {{ $t('sliders.labelPlusIcon') }}
              </div>
              <va-slider
                v-model="value"
                color="danger"
                icon-right="fa fa-check-circle"
                value-visible
              />
            </div>
            <div class="flex xs12 lg6 xl4 mb-2">
              <div class="title mb-3" :style="{ color: this.$themes.primary }">
                {{ $t('sliders.pins') }}
              </div>
              <va-slider v-model="value" pins :step="20" />
            </div>
            <div class="flex xs12 lg6 xl4 mb-2">
              <div
                class="title title--warning mb-3"
                :style="{ color: this.$themes.warning }"
              >
                {{ $t('sliders.pinsAndValue') }}
              </div>
              <va-slider
                v-model="value"
                pins
                :step="10"
                color="warning"
                value-visible
              />
            </div>
            <div class="flex xs12 lg6 xl4 mb-2">
              <va-slider v-model="value" value-visible with-input />
            </div>
            <div class="flex xs12 lg6 xl4 mb-2">
              <va-slider
                v-model="value"
                color="info"
                icon="fa fa-volume-off"
                icon-right="fa fa-volume-up"
              />
            </div>
          </div>
        </va-card>
      </div>
      <div class="flex md12">
        <va-card :title="$t('sliders.range')">
          <div class="row">
            <div class="flex xs12 lg6 xl4 mb-2">
              <div class="title mb-3" :style="{ color: this.$themes.primary }">
                {{ $t('sliders.simple') }}
              </div>
              <va-slider v-model="value2" range />
            </div>
            <div class="flex xs12 lg6 xl4 mb-2">
              <div
                class="title title--danger mb-3"
                :style="{ color: this.$themes.danger }"
              >
                {{ $t('sliders.value') }}
              </div>
              <va-slider v-model="value2" range color="danger" value-visible />
            </div>
            <div class="flex d-flex align--end xs12 lg6 xl4 mb-2">
              <va-slider
                v-model="value2"
                range
                :label="$t('sliders.label')"
                color="info"
                value-visible
              />
            </div>
            <div class="flex d-flex align--end xs12 lg6 xl4 mb-2">
              <va-slider
                v-model="value2"
                range
                :label="$t('sliders.label')"
                :invert-label="true"
                color="warning"
                value-visible
              />
            </div>
            <div class="flex xs12 lg6 xl4 mb-2">
              <div class="title mb-3" :style="{ color: this.$themes.primary }">
                {{ $t('sliders.labelPlusIcon') }}
              </div>
              <va-slider v-model="value2" range icon="fa fa-music" />
            </div>
            <div class="flex xs12 lg6 xl4 mb-2">
              <div
                class="title title--danger mb-3"
                :style="{ color: this.$themes.danger }"
              >
                {{ $t('sliders.labelPlusIcon') }}
              </div>
              <va-slider
                v-model="value2"
                range
                color="danger"
                icon-right="fa fa-check-circle"
                value-visible
              />
            </div>
            <div class="flex xs12 lg6 xl4 mb-2">
              <div class="title mb-3" :style="{ color: this.$themes.primary }">
                {{ $t('sliders.pins') }}
              </div>
              <va-slider v-model="value2" range pins :step="20" />
            </div>
            <div class="flex xs12 lg6 xl4 mb-2">
              <div
                class="title title--warning mb-3"
                :style="{ color: this.$themes.warning }"
              >
                {{ $t('sliders.pinsAndValue') }}
              </div>
              <va-slider
                v-model="value2"
                range
                pins
                :step="10"
                color="warning"
                value-visible
              />
            </div>
            <div class="flex xs12 lg6 xl4 mb-2">
              <va-slider v-model="value2" range with-input />
            </div>
            <div class="flex xs12 lg6 xl4 mb-2">
              <va-slider
                v-model="value2"
                range
                color="info"
                icon="fa fa-volume-off"
                icon-right="fa fa-volume-up"
              />
            </div>
          </div>
        </va-card>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Sliders',
  data() {
    return {
      value: 90,
      value2: [20, 60],
    }
  },
}
</script>
