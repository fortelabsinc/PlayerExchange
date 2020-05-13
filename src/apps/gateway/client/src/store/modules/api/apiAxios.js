import axios from 'axios'

// TODO: Move baseUrl var to .env
const apiAxios = axios.create({
  baseURL: '/portal/commands/v1',
  timeout: 1000,
  headers: { 'Content-Type': 'application/json' },
})

export const setApiAuthToken = (token) => {
  apiAxios.defaults.headers.common['access-token'] = token
}

export const clearApiAuthToken = () => {
  apiAxios.defaults.headers.common['access-token'] = null
}

export default apiAxios
