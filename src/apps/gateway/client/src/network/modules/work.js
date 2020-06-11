import axios from 'axios'
import store from '../../store'

export default {
  postings(cb) {
    axios
      .get('/portal/commands/v1/work/posting', {
        headers: { 'access-token': store.getters.authToken },
      })
      .then(function (response) {
        if (undefined != response.data.ok) {
          //store.commit('setWorkPostings', response.data);
          cb(true, response.data.ok)
        } else {
          cb(false, response.data.error)
        }
      })
      .catch((err) => {
        cb(false, err)
      })
  },
  userPostings(cb) {
    axios
      .get('/portal/commands/v1/work/posting/' + store.getters.authUserName, {
        headers: { 'access-token': store.getters.authToken },
      })
      .then(function (response) {
        if (undefined != response.data.ok) {
          cb(true, response.data.ok)
        } else {
          cb(false, response.data.error)
        }
      })
      .catch((err) => {
        cb(false, err)
      })
  },
  createPosting(data, cb) {
    axios
      .post(
        '/portal/commands/v1/work/posting',
        // Body
        data,
        // Headers
        {
          headers: { 'access-token': store.getters.authToken },
        }
      )
      .then(function (response) {
        if (undefined != response.data.ok) {
          cb(true, response.data.ok)
        } else {
          cb(false, response.data.error)
        }
      })
      .catch((err) => {
        cb(false, err)
      })
  },
  deletePosting(postingId, cb) {
    axios
      .delete('/portal/commands/v1/work/posting/' + postingId, {
        headers: { 'access-token': store.getters.authToken },
      })
      .then(function (response) {
        if (undefined != response.data.ok) {
          cb(true, response.data.ok)
        } else {
          cb(false, response.data.error)
        }
      })
      .catch((err) => {
        cb(false, err)
      })
  },
  deleteAllPosting(cb) {
    axios
      .delete('/portal/commands/v1/work/posting', {
        headers: { 'access-token': store.getters.authToken },
      })
      .then(function (response) {
        if (undefined != response.data.ok) {
          cb(true, response.data.ok)
        } else {
          cb(false, response.data.error)
        }
      })
      .catch((err) => {
        cb(false, err)
      })
  },
}
