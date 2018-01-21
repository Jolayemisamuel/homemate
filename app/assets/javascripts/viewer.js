import '../stylesheets/viewer'

import 'jquery-ujs'
import 'bootstrap'

import fontawesome from '@fortawesome/fontawesome'
import '@fortawesome/fontawesome-free-solid'
import '@fortawesome/fontawesome-free-regular'
import '@fortawesome/fontawesome-free-brands'

window.$ = $

$(document).ready(function() {
    const callback = function (mutationsList) {
        for (let mutation of mutationsList) {
            mutation.addedNodes.forEach(function () {
                fontawesome.dom.i2svg(this)
            })

        }
    }
})