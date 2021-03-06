insert_into_file 'config/application.rb', after: 'config.load_defaults 5.2' do
  <<-GENERATOR_CONFIGS

    config.generators do |g|
      g.test_framework  false
      g.stylesheets     false
      g.javascripts     false
      g.helper          false
      g.channel         assets: false
    end
  GENERATOR_CONFIGS

end

file 'config/webpack/staging.js'
append_to_file 'config/webpack/staging.js' do
  <<-STAGING_CONFIG
  process.env.NODE_ENV = process.env.NODE_ENV || 'staging'

  const environment = require('./environment')

  module.exports = environment.toWebpackConfig()

  STAGING_CONFIG
end

insert_into_file 'config/webpacker.yml', after: 'public_output_path: packs-test\n' do
  <<-ADD_STAGING_ENVIRONMENT
    staging:
      <<: *default

  ADD_STAGING_ENVIRONMENT
end



run 'yarn add turbolinks @fortawesome/fontawesome-free'

# run 'yarn upgrade webpack-dev-server --latest'
# run 'yarn install'
# run 'yarn add rails-ujs turbolinks stimulus babel-minify'
# run 'yarn add rails-ujs turbolinks jquery stimulus bourbon bootstrap babel-minify popper.js @fortawesome/fontawesome @fortawesome/fontawesome-free-solid @fortawesome/fontawesome-free-regular @fortawesome/fontawesome-free-brands'


# yarn add @fortawesome/fontawesome-free
# yarn add @fortawesome/fontawesome-free-regular
# yarn add @fortawesome/fontawesome-free-solid
# yarn add @fortawesome/fontawesome-free-brands
# add a staging environment in config/webpacker.yml
# update version of node on server
run 'rails webpacker:install:stimulus'

append_to_file 'config/webpack/environment.js' do
  <<-RAILS_UJS_INCLUDE
  const webpack = require('webpack')
  environment.plugins.append('Provide', new webpack.ProvidePlugin({
    Rails: '@rails/ujs'
  }))
  RAILS_UJS_INCLUDE
end
