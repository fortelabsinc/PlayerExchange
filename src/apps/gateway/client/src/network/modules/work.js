
import axios from 'axios'
import store from '../../store';

export default {
  postings(cb) {
    axios.get('/portal/commands/v1/work/postings', {
      headers: { 'access-token': token }
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
  }
}