
import axios from 'axios'
import store from '../../store';

export default {
  postings(cb) {
    axios.get('/portal/commands/v1/work/postings', {
      headers: { 'access-token': store.getters.authToken }
    })
      .then(function(response) {
        if (undefined != response.data) {
          store.commit('setWorkPostings', response.data);
          cb(true, response.data);
        }
        else {
          cb(false, response.data.error);
        }
      })
      .catch((err) => {
        cb(false, err);
      })
  },
  createPosting(data, cb) {
    axios.post('/portal/commands/v1/work/posting',
      // Body
      data,
      // Headers
      {
        headers: { 'access-token': store.getters.authToken }
      }
    )
      .then(function(response) {
        if (undefined != response.data.ok) {
          cb(true, response.data.ok);
        }
        else {
          cb(false, response.data.error);
        }
      })
      .catch((err) => {
        cb(false, err);
      })
  }

}