const { createRunOncePlugin } = require('@expo/config-plugins')
const pkg = require('rn-yandex-appmetrica/package.json')

const withAppMetrica = (config) => config

module.exports = createRunOncePlugin(withAppMetrica, pkg.name, pkg.version)
