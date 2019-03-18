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

insert_into_file 'webpacker.yml', after: 'public_output_path: packs-test\n' do
<<-ADD_STAGING_ENVIRONMENT
  staging:
    <<: *default

ADD_STAGING_ENVIRONMENT
end

run 'yarn add @rails/webpacker@^4.0.0-rc.7 webpack-cli rails-ujs turbolinks stimulus @fortawesome/fontawesome-free'

run 'yarn upgrade webpack-dev-server --latest'
# run 'yarn install'
# run 'yarn add rails-ujs turbolinks stimulus babel-minify'
# run 'yarn add rails-ujs turbolinks jquery stimulus bourbon bootstrap babel-minify popper.js @fortawesome/fontawesome @fortawesome/fontawesome-free-solid @fortawesome/fontawesome-free-regular @fortawesome/fontawesome-free-brands'


# yarn add @fortawesome/fontawesome-free
# yarn add @fortawesome/fontawesome-free-regular
# yarn add @fortawesome/fontawesome-free-solid
# yarn add @fortawesome/fontawesome-free-brands
# add a staging environment in config/webpacker.yml
# update version of node on server

append_to_file 'config/webpack/environment.js' do
  <<-POSTCSS_LOADER
  const path = require("path")
  Object.assign(environment.loaders.get("css").use.find(el => el.loader === "postcss-loader").options, {
    config: {
      path: path.resolve(__dirname, "../..", ".postcssrc.yml")
    }
  })
  POSTCSS_LOADER
end
