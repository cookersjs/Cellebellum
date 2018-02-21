path = require('path');
webpack = require('webpack'),
postcss = require('postcss-loader');
autoprefixer = require('autoprefixer');

ExtractTextPlugin = require('extract-text-webpack-plugin');

commonLoaders = require('./commonLoaders');
bootstrapEntryPoints = require('./webpack.bootstrap.config');

const istanbulLoader = {
  // match all non-spec files
  test: /^((?!spec).)*.litcoffee$/,
  loader: 'istanbul-instrumenter-loader!coffee-loader',
  exclude: [
    'node_modules'
  ]
}

const coffeeLoader = {
  // match spec coffee files
  test: /spec.litcoffee$/,
  loader: 'coffee-loader',
  exclude: [
    'node_modules'
  ]
}

config = {
  devtool: 'inline-source-map',

  module: {
    loaders: commonLoaders.concat([istanbulLoader, coffeeLoader])
  },

  resolve: {
    modules: [
      'node_modules',
      'src/app/partials',
      'src/app',
      'common',
      'src/test/data'
    ],
    extensions: ['.js', '.litcoffee', '.html'],
    alias: {
      config: path.join(__dirname, '..', 'config', 'front-end', process.env.NODE_ENV)
    }
  },

  plugins: [
    new ExtractTextPlugin({ filename: 'cellebellum.css', allChunks: true }),
    new webpack.LoaderOptionsPlugin({
      postcss: [postcss]
    }),
    new webpack.ProvidePlugin({
      'window.Tether': 'tether'
    }),
    new webpack.ProvidePlugin({
      $: 'jquery',
      jQuery: 'jquery',
      'window.jQuery': 'jquery'
    }),
    new webpack.ProvidePlugin({
      d3: 'd3'
    }),
    new webpack.ProvidePlugin({
      XDate: 'xdate'
    }),
    new webpack.IgnorePlugin(/jsdom$/)
  ],
};

module.exports = config;
