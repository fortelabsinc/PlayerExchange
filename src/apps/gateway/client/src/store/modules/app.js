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
  authUserName: '',
  authEmail: '',
  authMeta: {},
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

  setAuthToken(token) {
    state.authToken = token
  },

  setAuthRefreshToken(token) {
    state.authToken = token
  },

  setAuthUserName(name) {
    state.authUserName = name
  },

  setAuthEmail(email) {
    state.authEmail = email
  },

  setAuthMeta(meta) {
    state.authMeta = meta
  },
  setWorkPostings(postings) {
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
