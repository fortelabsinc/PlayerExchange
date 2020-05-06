const state = {
  sidebar: {
    opened: false,
  },
  config: {
    palette: {
      primary: '#4ae387',
      danger: '#e34a4a',
      info: '#4ab2e3',
      success: '#db76df',
      warning: '#f7cc36',
      white: '#fff',
      black: '#000',
      fontColor: '#34495e',
      transparent: 'transparent',
      lighterGray: '#ddd',
    },
  },
  isLoading: true,

  // Login State Info
  authToken: '',
  authRefreshToken: '',
  authUserName: 'Michael Scott',
  authEmail: 'michael_scarn@office.the',
  authPayId: 'prison_mike$office.the',
  authMeta: {},
  authBalance: [
    { id: 'XRP', balance: 123 },
    { id: 'BTC', balance: 0.1234 },
    { id: 'ETH', balance: 1.23 }
  ],
  workPostings: [],
  games: [
    "World of Warcraft",
    "Fortnite",
    "Call of Duty: Warzone",
    "7 Days to Die!",
    "Overwatch",
    "Apex Legends",
    "PUBG",
    "Destiny",
    "Destiny 2",
    "Counter-Strike: G.O."
  ],
  currencies: [
    "XRP",
    "BTC",
    "ETH"
  ]
}

const mutations = {
  setLoading(state, isLoading) {
    state.isLoading = isLoading
  },

  setAuthToken(state, token) {
    state.authToken = token
  },

  setAuthRefreshToken(state, token) {
    state.authRefreshToken = token
  },

  setAuthUserName(state, name) {
    state.authUserName = name
  },

  setAuthEmail(state, email) {
    state.authEmail = email
  },

  setAuthMeta(state, meta) {
    state.authMeta = meta
  },
  setWorkPostings(state, postings) {
    state.workPostings = postings
  },
}

const actions = {
}

export default {
  state,
  mutations,
  actions,
}
