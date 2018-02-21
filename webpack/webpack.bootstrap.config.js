const fs = require('fs');

console.log('Using the bootstrap-loader default configuration.');

// DEV and PROD have slightly different configurations
var bootstrapDevEntryPoint;

module.exports = {
  dev: 'bootstrap-loader',
  prod: 'bootstrap-loader/extractStyles',
};
