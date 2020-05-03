import axios from 'axios'
import store from '../../store';

export default {
  login(email, password, cb) {
    axios.post('/portal/commands/v1/auth/login', {
      username: email,
      password: password,
    })
      .then(function(response) {
        if (undefined != response.data.ok) {
          store.commit('setAuthUserName', email);
          store.commit('setAuthEmail', email)
          store.commit('setAuthToken', response.data.ok.access_token);
          store.commit('setAuthRefreshToken', response.data.ok.refresh_token);
          store.commit('setAuthMeta', response.data.ok.meta)
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
  logout(email, password, cb) {
    axios.post('/portal/commands/v1/auth/login', {
      username: email,
      password: password,
    })
      .then(function(response) {
        const data = response.data.ok;
        cb(true, data)
      })
      .catch((err) => {
        cb(false, err)
      })
  },
  check(token, cb) {
    // Need to pull the access token out of the storage
    axios.get('/portal/commands/v1/auth/check', {
      headers: { 'access-token': token }
    })
      .then(function(response) {
        if (undefined != response.data.ok) {
          store.commit('setAuthEmail', response.data.ok.email);
          store.commit('setAuthUserName', response.data.ok.username);
          store.commit('setAuthMeta', response.data.ok.meta)
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

  refresh() {

  },
  register(username, email, password, cb) {
    axios.post('/portal/commands/v1/auth/register', {
      username: username,
      password: password,
      password_confirm: password,
      email: email,
      meta: {}
    })
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
  reset_password() {

  },
  change_password() {

  },
  forgot_username() {

  }
}