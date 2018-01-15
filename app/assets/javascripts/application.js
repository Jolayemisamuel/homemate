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
    const callback = function(mutationsList) {
        for (let mutation of mutationsList) {
            mutation.addedNodes.forEach(function() {
                fontawesome.dom.i2svg(this)
            })

        }
    }

    let observer = new MutationObserver(callback)
    observer.observe(document.documentElement, {
        childList: true
    })
})