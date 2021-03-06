#  https://www.artmann.co/articles/adding-tailwind-css-to-your-rails-app

run 'yarn add tailwindcss @tailwindcss/custom-forms tailwindcss-stimulus-components @fullhuman/postcss-purgecss'

insert_into_file 'postcss.config.js', before: "module.exports = {\n" do
  <<-POSTCSS_config
var tailwindcss = require('tailwindcss');
  POSTCSS_config
end

insert_into_file 'postcss.config.js', after: "plugins: [\n" do
  <<-POSTCSS_config
    tailwindcss('./app/javascript/css/tailwind.config.js'),
    require('autoprefixer'),
  POSTCSS_config
end

insert_into_file 'app/javascript/css/tailwind.config.js', after: "plugins: [\n" do
  <<-TAILWINDCSS_CUSTOM_FORMS
    require('@tailwindcss/custom-forms')
  TAILWINDCSS_CUSTOM_FORMS
  end


# append_to_file 'app/javascript/css/tailwind.config.js'  do
#   <<-TAILWINDCSS_CUSTOM_FORMS
#   if (process.env.RAILS_ENV === "production" || process.env.RAILS_ENV === "staging" ) {
#     environment.plugins.push(
#       require('@fullhuman/postcss-purgecss')({
#         content: [
#           './app/**/*.html.erb',
#           './app/**/*.html.haml',
#           './app/helpers/**/*.rb',
#           './app/javascript/**/*.js',
#           './app/javascript/**/*.vue',
#           './app/javascript/**/*.sass',
#         ],
#         defaultExtractor: content => content.match(/[A-Za-z0-9-_:/]+/g) || []
#       })
#     )
#   }
#   TAILWINDCSS_CUSTOM_FORMS
#   end