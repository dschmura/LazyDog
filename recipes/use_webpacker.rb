file '.browserlistrc'
append_to_file '.browserlistrc' do
  # Global config for browserslist, that tools like Autoprefixer are going to need to correctly process your code to be cross-browser compliant. (https://evilmartians.com/chronicles/evil-front-part-1)
  "> 1%"
end

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

run 'mv app/javascript app/webpacker'

gsub_file('config/webpacker.yml',  'source_path: app/javascript', 'source_path: app/webpacker')

run 'yarn add rails-ujs turbolinks jquery stimulus bourbon bootstrap babili popper.js @fortawesome/fontawesome @fortawesome/fontawesome-free-solid @fortawesome/fontawesome-free-regular @fortawesome/fontawesome-free-brands'

run 'yarn add webpack-cli -D'
