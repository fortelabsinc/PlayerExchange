import axios from 'axios'
import store from '../../store';

export default {

  payment(data, cb) {
    axios.post('/portal/commands/v1/wallet/payment',
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
  },

  balances(cb) {
    axios.get('/portal/commands/v1/wallet/balance',
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