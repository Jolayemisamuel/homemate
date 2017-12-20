const { environment } = require('@rails/webpacker');
const webpack = require('webpack');

environment.plugins.set(
    'Provide',
    new webpack.ProvidePlugin({
        $: 'jquery',
        jQuery: 'jquery',
        Popper: ['popper.js', 'default'],
        fontawesome: '@fortawesome/fontawesome',
        solid: '@fortawesome/fontawesome-free-solid',
        regular: '@fortawesome/fontawesome-free-regular',
        brands: '@fortawesome/fontawesome-free-brands'
    })
);
module.exports = environment;
