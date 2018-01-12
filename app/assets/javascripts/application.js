import '../stylesheets/application'
import '../images/logo.png'

import 'jquery-ujs'
import 'bootstrap'

import { Application } from 'stimulus'
import { autoload } from 'stimulus/webpack-helpers'

import fontawesome from '@fortawesome/fontawesome'
import '@fortawesome/fontawesome-free-solid'
import '@fortawesome/fontawesome-free-regular'
import '@fortawesome/fontawesome-free-brands'

import Turbolinks from 'turbolinks'

window.$ = $

const application = Application.start()
const controllers = require.context('../controllers', true, /\.js$/)

autoload(controllers, application)
Turbolinks.start()
$(document).ready(function() {
    $(document).on('load', 'i', function(event) {
        fontawesome.dom.i2svg(this)
    })
})