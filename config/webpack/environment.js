const { environment } = require('@rails/webpacker');
const webpack = require('webpack');

environment.plugins.set(
    'Provide',
    new webpack.ProvidePlugin({
        $: 'jquery',
        axios: 'axios',
        StreamSaver: 'streamsaver',
        jQuery: 'jquery',
        Popper: ['popper.js', 'default'],
    })
);
module.exports = environment;
