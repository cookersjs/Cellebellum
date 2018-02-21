module.exports = [
  { 
    test: /\.html$/,
    loader: 'html-loader', exclude: ['node_modules']
  },

  {
    test: /\.woff2?$/,
    loader: 'url-loader'
  },

  { 
    test: /\.(ttf|eot|svg|gif|png)(\?[\s\S]+)?$/,
    loader: 'file-loader'
  },

  {
  test: /\.css$/, 
  exclude: ['/node_modules/'],
  use: ExtractTextPlugin.extract({ fallback: 'style-loader', use: 'css-loader'})
  },

  {
  test: /\.scss$/,
  exclude: ['/node_modules/'],
  use: ExtractTextPlugin.extract({ fallback: 'style-loader', use: 'css-loader!sass-loader'})
  },
]
