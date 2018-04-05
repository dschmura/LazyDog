def source_paths
  Array(super) + [File.join(File.expand_path(File.dirname(__FILE__)),'recipes')] + [File.join(File.expand_path(File.dirname(__FILE__)),'baseapp')]

end
def template_with_env filename
  if ENV['LOCAL']
    "/Users/dschmura/code/Rails/TEMPLATES/LazyDog/recipes" + filename
  else
    "http://github.com/smartlogic/rails-templates/raw/master/" + filename
  end
end

# Loads templates from the recipes/ directory (located in the same directory as this template).
# This allows us to load templates in the form: load_template('rails_flash_messages.rb')
def load_template(template)
  begin
    template = File.join(File.dirname(__FILE__), "/recipes/#{template}")
    code = open(template).read
    in_root { self.instance_eval(code) }
  rescue LoadError, Errno::ENOENT => e
    raise "The template [#{template}] could not be loaded. Error: #{e}"
    end
end

def add_users
end

def add_bootstrap
end

def add_rails_flash_messages
  load_template('rails_flash_messages.rb')
end

def copy_templates
  directory '../baseapp/app', 'app',  force: true
  directory '../baseapp/config', 'config', force: true
  directory '../baseapp/spec', 'spec',  force: true

  copy_file '../baseapp/Capfile', 'Capfile', force: true
  copy_file '../baseapp/Gemfile', 'Gemfile', force: true
  # copy_file '../baseapp/package.json', 'package.json', force: true
  copy_file '../baseapp/Procfile', 'Procfile'
end

def add_webpack
  load_template('use_webpacker.rb')
end

def add_sidekiq
  # environment "config.active_job.queue_adapter = :sidekiq"
  #
  # insert_into_file "config/routes.rb",
  #   "require 'sidekiq/web'\n\n",
  #   before: "Rails.application.routes.draw do"
  #
  # insert_into_file "config/routes.rb",
  #   "  authenticate :user, lambda { |u| u.admin? } do\n    mount Sidekiq::Web => '/sidekiq'\n  end\n\n",
  #   after: "Rails.application.routes.draw do\n"
end

def add_feedback_mailer
  load_template('add_feedback_mailer.rb')
end

def add_notifications
end

def add_announcements
end

def add_multiple_authentication
end

def add_rspec
  # Bundle and set up RSpec
  run 'bundle exec rails generate rspec:install'
end

def add_capistrano
  load_template('use_capistrano.rb')
end

def add_static_pages
  generate(:controller, "Pages index about contact privacy")
  route "root to: 'pages#index'"
  route "get '/about', to: 'pages#about'"
  route "get '/contact', to: 'pages#contact'"
  route "get '/privacy', to: 'pages#privacy'"
end

def add_administrate
end

def customize_configs
  run "mv app/webpacker/app_name app/webpacker/#{app_name}"
  gsub_file 'package.json', 'app_name', "#{app_name}"
  gsub_file 'app/webpacker/packs/application.js', 'app_name', "#{app_name}"
  gsub_file 'config/database.yml', 'app_name', "#{app_name}"
  gsub_file 'config/puma.sample.rb', 'app_name', "#{app_name}"
  gsub_file 'config/nginx.sample.conf', 'app_name', "#{app_name}"
  gsub_file 'config/deploy.rb', 'app_name', "#{app_name}"
  gsub_file 'config/deploy/production.rb', 'PRODUCTION_SERVER_IP', "#{app_name}.com"
  gsub_file 'config/deploy/staging.rb', 'STAGING_SERVER_IP', "#{app_name}.com"
  gsub_file 'config/locales/en.yml', "hello: \"Hello world\"", "sitename: \"#{app_name}\""
  gsub_file 'bin/setup', "# system('bin/yarn')", "system('bin/yarn')"

end

def update_app_name
  puts Dir.pwd
  Dir.glob("app/**/*.*")  {|filename| gsub_file filename, 'app_name', "#{app_name}" }
  Dir.glob("config/**/*.*")  {|filename| gsub_file filename, 'app_name', "#{app_name}" }
end

def run_certbot
  # is this a template concern or a deployment rake task?
end

def convert_to_haml
  rails_command('haml:replace_erbs')
  run 'rm -rf app/views/'
end

def config_missing_translations
  # RAISE ERROR IF TRANSLATION IS MISSING (ie: site_name)
  insert_into_file 'config/environments/development.rb', after: 'config.eager_load = false' do
    <<-CONFIG

        config.action_view.raise_on_missing_translations = true

    CONFIG
  end
  insert_into_file 'config/environments/test.rb', after: 'config.eager_load = false' do
    <<-CONFIG

        config.action_view.raise_on_missing_translations = true

    CONFIG
  end
end

def add_favicon_and_logo
  load_template('create_favicon.rb')
end

# Main setup
# add_gems
copy_file '../baseapp/Gemfile', 'Gemfile', force: true
run 'bundle install'
after_bundle do
  add_users
  add_bootstrap
  add_rails_flash_messages
  add_sidekiq
  add_webpack
  # add_announcements
  # add_notifications
  # add_multiple_authentication
  add_feedback_mailer
  # add_administrate
  add_capistrano
  add_rspec
  convert_to_haml
  add_static_pages
  copy_templates
  customize_configs
  update_app_name
  add_favicon_and_logo
  config_missing_translations

  run 'bin/setup'
  # Migrations must be done before this
  add_administrate

  git :init
  append_to_file '.gitignore' do ".DS_Store" end
  git add: "."
  git commit: %Q{ -m 'Initial Commit' }
  # Create respitory on github. This requires Hub [https://github.com/github/hub]
  # run 'git create'
  run 'atom .'
end
