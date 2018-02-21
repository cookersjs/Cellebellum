path = require('path');
commonConfig = require('./webpack.js');

output = {
  path: path.resolve(__dirname, 'build'),
  filename: 'cellebellum.js'
};

module.exports = Object.assign(commonConfig, {
  output: output,
  devtool: 'source-map',
  plugins: commonConfig.plugins
});
