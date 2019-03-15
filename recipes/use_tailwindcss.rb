#  https://www.artmann.co/articles/adding-tailwind-css-to-your-rails-app
run 'yarn add --dev autoprefixer tailwindcss'
run './node_modules/.bin/tailwind init app/javascript/css'

insert_into_file 'postcss.config.js', after: "module.exports = {\n" do
  var tailwindcss = require('tailwindcss');
end

insert_into_file 'postcss.config.js', before: "plugins: [\n" do
  <<-POSTCSS_config
    tailwindcss('./app/javascript/css/tailwind.js'),
    require('autoprefixer'),
  POSTCSS_config
end
