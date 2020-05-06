<template>
  <va-card :title="$t('postings.table.all.title')">
    <va-data-table
      :fields="fields"
      :data="postings"
      :loading="loading"
      hoverable
    >
      <!--
      <template slot="icon">
        <va-icon name="fa fa-user" color="secondary" />
      </template>
      <template v-slot:starred="props">
        <va-icon
          v-if="props.rowData.starred"
          name="fa fa-star"
          color="warning"
        />
      </template>
      <template v-slot:status="props">
        <va-badge :color="getStatusColor(props.rowData.status)">
          {{ props.rowData.status }}
        </va-badge>
      </template>
      -->
      <template v-slot:actions="props">
        <va-button
          small
          outline
          color="success"
          class="ma-0"
          @click="showDetailsModal(props.rowData)"
        >
        Details
        <!--
          {{ $t('dashboard.table.resolve') }}
        -->
        </va-button>

        <va-modal
          v-model="isModalVisible"
          size="large"
          position="top"
          hideDefaultActions
          :title=" $t('postingDetails.modal.title') "
          class="flex"
        >
          <dashboard-posting-details :posting="selectedPosting" />
          <div class="mt-3 mb-3 va-modal__actions">
            <va-button
              flat
              color="gray"
              @click="isModalVisible = false"
            >
              {{ $t('postingDetails.modal.close') }}
            </va-button>
          </div>
        </va-modal>
      </template>
    </va-data-table>
  </va-card>
</template>

<script>
import store from '@/store';
import Network from '@/network'
import auth from '../../network/modules/auth';
import DashboardPostingDetails from './DashboardPostingDetails'

export default {
  name: 'dashboard-all-postings-table',
  components: {
    DashboardPostingDetails,
  },
  data () {
    return {
      postings: [
        //{
        //  type_req: "Group",
        //  user_id: "cjimison@forte.io",
        //  game_id: "World of Warcraft",
        //  details: "Need help to finish thing",
        //  complete_pay_amt: "100",
        //  complete_pay_type: "XRP",
        //}
      ],
      loading: false,
      term: null,
      mode: 0,
      isModalVisible: false,
      selectedPosting: {}
    }
  },
  computed: {
    fields () {
      return [
      {
        name: 'game_id',
        title: 'Game',//this.$t('tables.headings.name'),
        width: '20%',
      },
      {
        name: 'type_req',
        title: 'Type', //this.$t('tables.headings.payid'),
        width: '5%',
      },
      {
        name: 'user_id',
        title: 'From', //this.$t('tables.headings.payid'),
        width: '10%',
      },
      {
        name: 'details',
        title: 'Details',//'this.$t('tables.headings.status'),
        width: '40%',
        //sortField: 'status',
      },
      {
        name: 'complete_pay_amt',
        title: 'Complete',//'this.$t('tables.headings.status'),
        width: '10%',
        //sortField: 'status',
      }, {
        name: 'complete_pay_type',
        title: 'Type',//'this.$t('tables.headings.status'),
        width: '10%',
        //sortField: 'status',
      },
      {
        name: '__slot:actions',
        dataClass: 'text-right',
      }]
    }
  },
  mounted() {
    this.loadPostings()
  },
  created() {
    this.$eventHub.$on('refresh-postings', this.loadPostings);
  },
  beforeDestroy() {
    this.$eventHub.$off('refresh-postings');
  },
  methods: {
    loadPostings() {
      var self = this;
      Network.work.postings((success, data) => {
        if(success)
        {
          self.postings = data;
        }
        else
        {
          console.log("Failed to load the postings: " + data)
        }
      });
    },
    showDetailsModal(data) {
      this.selectedPosting = data;
      this.isModalVisible = true;
    }
  },
}
</script>

<style lang="scss">
</style>
