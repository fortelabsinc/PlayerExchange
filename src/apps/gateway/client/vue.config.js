const path = require('path')

module.exports = {
  transpileDependencies: ['vuetify'],
  publicPath: "/portal/client/v1",
  outputDir: path.resolve(__dirname, "../priv/static/client/v1"),
}
