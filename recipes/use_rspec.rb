 # Bundle and set up RSpec
 gem_group :development, :test do
  gem "rspec-rails"
end

 run 'bundle exec rails generate rspec:install'
 run 'guard init'

 insert_into_file 'spec/rails_helper.rb', after: "RSpec.configure do |config|\n" do
  <<~EOF
  config.include Warden::Test::Helpers

  EOF
 end

insert_into_file 'config/application.rb', after: 'config.generators.system_tests = nil\n' do
  <<-CONFIG_RSPEC

  config.generators do |g|
    g.javascript_engine :js
    g.helper false

    g.test_framework :rspec,
      fixtures: false,
      view_specs: false,
      helper_specs: false,
      routing_specs: false,
      request_specs: false,
      controller_specs: false
  end

  CONFIG_RSPEC
end


file '.rspec' unless File.exist?('./.rspec')

append_to_file '.rspec' do
 ' --require spec_helper'
end

file "./spec/support/factory_bot.rb"
append_to_file './spec/support/factory_bot.rb' do
  <<-CONFIG_RSPEC
  require 'factory_bot_rails'
  RSpec.configure do |config|
    config.include FactoryBot::Syntax::Methods
  end
  CONFIG_RSPEC
end
