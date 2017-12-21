import '../stylesheets/application';
import '../images/logo.png';

import 'jquery-ujs';
import 'bootstrap';

import Turbolinks from 'turbolinks';
import fontawesome from '@fortawesome/fontawesome';
import '@fortawesome/fontawesome-free-solid';
import '@fortawesome/fontawesome-free-regular';
import '@fortawesome/fontawesome-free-brands';

window.$ = $;

Turbolinks.start();
$(document).on('turbolinks:load', function() {
   fontawesome.dom.i2svg();
});