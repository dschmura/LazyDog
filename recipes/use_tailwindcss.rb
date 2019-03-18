#  https://www.artmann.co/articles/adding-tailwind-css-to-your-rails-app
run 'yarn add --dev autoprefixer tailwindcss'
run './node_modules/.bin/tailwind init app/javascript/css/tailwind.js'

insert_into_file 'postcss.config.js', before: "module.exports = {\n" do
  <<-POSTCSS_config
var tailwindcss = require('tailwindcss');
  POSTCSS_config
end

insert_into_file 'postcss.config.js', after: "plugins: [\n" do
  <<-POSTCSS_config
    tailwindcss('./app/javascript/css/tailwind.js'),
    require('autoprefixer'),
  POSTCSS_config
end
