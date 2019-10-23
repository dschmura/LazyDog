insert_into_file "README.md", after: "* System dependencies\n" do
  <<-DEVISE_README

    ## Authorization - DEVISE
     This application uses Devise for user authorization.

  DEVISE_README
end

gem 'devise'

run "bundle install"

run "bundle exec rails generate devise:install"
run "bundle exec rails generate devise User"
gsub_file 'config/puma.sample.rb', 'app_name', "#{app_name}"





insert_into_file "config/environments/development.rb", after: "Rails.application.configure do\n" do
  "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }"
end
