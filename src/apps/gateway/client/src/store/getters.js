const config = state => state.app.config
const palette = state => state.app.config.palette
const isLoading = state => state.app.isLoading
const authToken = state => state.app.authToken
const authRefreshToken = state => state.app.authRefreshToken
const authUserName = state => state.app.authUserName
const authEmail = state => state.app.authEmail
const authMeta = state => state.app.authMeta

export {
  config,
  palette,
  isLoading,
  // Auth info
  authToken,
  authRefreshToken,
  authUserName,
  authEmail,
  authMeta
}
