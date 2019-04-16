// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("@rails/activestorage").start()
require("channels")

var Turbolinks = require("turbolinks")
Turbolinks.start()

import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"

const application = Application.start()
const context = require.context("../controllers", true, /\.js$/)
application.load(definitionsFromContext(context))

// Specific frontend applications
import 'app_name'

import 'app_name/stylesheets/_variables.sass'
import 'app_name/stylesheets/application.sass'
import 'app_name/stylesheets/_header.sass'
import 'app_name/stylesheets/_flash_errors.sass'
import 'app_name/stylesheets/_footer.sass'
import 'app_name/stylesheets/ribbons.sass'

import '@fortawesome/fontawesome-free/js/all';
require.context('../app_name/images/', true, /.(gif|jpg|jpeg|png|svg)$/)

document.addEventListener('turbolinks:load', () => {
  // FontAwesome.dom.i2svg();
})

document.addEventListener('turbolinks:load', () => {

  // FontAwesome.dom.i2svg();
  function highlightCurrent() {
    const curPage = document.URL;
    const links = document.getElementsByTagName('a');
    for (let link of links) {
      if (link.href == curPage) {
        link.classList.add("current");
      }
    }
  }

  highlightCurrent();
  document.getElementById('nav-toggle').onclick = function () {
    document.getElementById("nav-content").classList.toggle("hidden");
  }
});