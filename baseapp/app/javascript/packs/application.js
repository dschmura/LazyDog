// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("@rails/activestorage").start()
require("channels")

var Turbolinks = require("turbolinks")
Turbolinks.start()

// import 'app_name'

// Specific frontend applications
import 'app_name/stylesheets/application.sass'
import 'app_name/stylesheets/_header.sass'
import 'app_name/stylesheets/_flash_errors.sass'
import 'app_name/stylesheets/_footer.sass'
import 'app_name/stylesheets/_feedback.sass'
import 'app_name/stylesheets/ribbons.sass'

import '@fortawesome/fontawesome-free/js/all';
require.context('../app_name/images/', true, /.(gif|jpg|jpeg|png|svg)$/)

// require('trix')
// require('@rails/actiontext')
// import 'trix/dist/trix.css'

document.addEventListener('turbolinks:load', () => {

  FontAwesome.dom.i2svg();
  function highlightCurrent() {
    const curPage = document.URL;
    const links = document.getElementsByTagName('a');
    for (let link of links) {
      if (link.href == curPage) {
        link.classList.add("current");
      }
    }
  }
});

import "controllers"