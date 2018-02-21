path = require('path'),
webpack = require('webpack'),
postcss = require('postcss-loader');
autoprefixer = require('autoprefixer');
express = require('express');

ExtractTextPlugin = require('extract-text-webpack-plugin');
UglifyJSPlugin = require('uglifyjs-webpack-plugin');
HtmlWebpackPlugin = require('html-webpack-plugin');

commonLoaders = require('./commonLoaders');
bootstrapEntryPoints = require('./webpack.bootstrap.config');

const coffeeLoader = {
  // match spec coffee files
  test: /\.litcoffee$/,
  loader: 'coffee-loader',
  exclude: [
    'node_modules'
  ]
}

config = {
  context: path.resolve(__dirname, '../src/'),
  devtool: 'source-map',
  entry: [
    bootstrapEntryPoints.prod,
    './app/app.litcoffee',
  ],

  output: {
    path: path.join(__dirname, '..', '.tmp', 'webapp'),
    filename: 'cellebellum.js',
  },

  module: {
    loaders: commonLoaders.concat([coffeeLoader])
  },

  resolve: {
    modules: [
      'node_modules',
      'src/app/partials',
      'src/app',
      'common',
      'configuration'
    ],
    extensions: ['.js', '.litcoffee', '.html'],
    alias: {
      config: path.join(__dirname, '..', 'config', 'front-end', process.env.NODE_ENV)
    }
  },

  plugins: [
    // Add environment variables
    new webpack.DefinePlugin({
        "process.env": {
          'NODE_ENV': JSON.stringify(process.env.NODE_ENV)
        }
    }),
    // new UglifyJSPlugin(),
    // Add various custom plugins for specific node modules that are fussy and/or are needed globally
    new ExtractTextPlugin({ filename: 'cellebellum.css', allChunks: true }),
    new HtmlWebpackPlugin({
      template: 'app/assets/index.html',
      filename: 'index.html'
    }),
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
  devServer: {
    inline: true,
    contentBase: './src/app',
    historyApiFallback: {
      rewrites: [{
        from: /^\/variants\/.*$/,
        to: function() {
          return '/';
        }
      }]
    }
  }
};

module.exports = config;
