#  https://www.artmann.co/articles/adding-tailwind-css-to-your-rails-app
# run 'yarn add --dev autoprefixer tailwindcss'
run 'yarn add -D tailwindcss@next'

run 'yarn add @tailwindcss/custom-forms'

# run './node_modules/.bin/tailwind init app/javascript/css/tailwind.config.js'

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