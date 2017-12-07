const { environment } = require('@rails/webpacker');
const webpack = require('webpack');

environment.plugins.set(
    'Provide',
    new webpack.ProvidePlugin({
        $: 'jquery',
        jQuery: 'jquery',
        Popper: ['popper.js', 'default'],
        Turbolinks: 'turbolinks',
        Slideout: 'slideout'
    })
);
module.exports = environment;
