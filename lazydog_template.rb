
require "fileutils"
require "shellwords"

# Copied from: https://github.com/mattbrictson/rails-template
# Add this template directory to source_paths so that Thor actions like
# copy_file and template resolve against our source files. If this file was
# invoked remotely via HTTP, that means the files are not present locally.
# In that case, use `git clone` to download them to a local temporary dir.
# def add_template_repository_to_source_path


def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    require "tmpdir"
    source_paths.unshift(tempdir = Dir.mktmpdir("lazydog-"))
    puts "#{source_paths.unshift(tempdir = Dir.mktmpdir("lazydog-"))}"
    at_exit { FileUtils.remove_entry(tempdir) }
    git clone: [
      # "--quiet",
      "https://github.com/dschmura/LazyDog.git",
      tempdir
    ].map(&:shellescape).join(" ")

    if (branch = __FILE__[%r{lazydog/(.+)/lazydog_template.rb}, 1])
      Dir.chdir(tempdir) { git checkout: branch }
    end
  else
    source_paths
  end
end

def source_paths
  Array(super) + [File.join(File.expand_path(File.dirname(__FILE__)),'recipes')] + [File.join(File.expand_path(File.dirname(__FILE__)),'baseapp')]
end

def template_with_env filename
  if ENV['LOCAL']
    "/Users/dschmura/code/Rails/TEMPLATES/LazyDog/recipes" + filename
  else
    "https://github.com/dschmura/LazyDog/recipes/" + filename
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

def add_social_links
  load_template('add_social_links.rb')
end

def add_notifications
end

def add_announcements
end

def use_docker
  load_template('use_docker.rb')
end

def add_multiple_authentication
end

def use_rspec
 load_template('use_rspec.rb')
end

def use_factory_bot
  load_template('use_factory_bot.rb')
end

def add_capistrano
  load_template('use_capistrano.rb')
end

def add_static_pages
  generate(:controller, "Pages index about contact privacy project_status")
  route "root to: 'pages#index'"
  route "get '/about', to: 'pages#about'"
  route "get '/contact', to: 'pages#contact'"
  route "get '/privacy', to: 'pages#privacy'"
  route "get '/project_status', to: 'pages#project_status'"
end

def add_administrate
end

def customize_configs
  load_template('customize_configs.rb')

end

def update_app_name
  puts "REMOVE ME"
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

def add_umich_colors
  load_template('use_umich_colors.rb')
end

def add_clear_dev_logs_initializer
  load_template('add_clear_dev_logs.rb')
end

def use_tailwindcss
  load_template('use_tailwindcss.rb')
end

def use_devise
  load_template('use_devise.rb')
end

def use_omniauth
  load_template('use_omniauth.rb')
end

def add_working_files
  load_template('add_working_files.rb')
end
# Main setup
# add_gems
copy_file '../baseapp/Gemfile', 'Gemfile', force: true
run 'bundle install'
after_bundle do
  add_template_repository_to_source_path
  add_users
  add_bootstrap
  add_rails_flash_messages
  add_sidekiq
  add_webpack
  # add_announcements
  # add_notifications
  # add_multiple_authentication

  # add_administrate
  add_capistrano

  use_rspec
  use_factory_bot
  convert_to_haml

  add_static_pages
  copy_templates
  add_feedback_mailer
  customize_configs
  use_tailwindcss
  add_social_links
  update_app_name
  add_favicon_and_logo

  # if yes? 'Do you want to add the Official UM color variables? (y/n)'
  #   add_umich_colors
  # end

  if yes? 'Do you want single signon?'
    use_devise
    use_omniauth
  end

  if yes? 'Do you want to use Docker? (y/n)'
    use_docker
  end
  config_missing_translations
  add_clear_dev_logs_initializer
  add_working_files

  rails_command("db:setup")
  rails_command("db:migrate")
  run 'bin/setup'
  # Migrations must be done before this
  # add_administrate


  git :init
  append_to_file '.gitignore' do ".DS_Store" end
  git add: "."
  git commit: %Q{ -m 'Initial Commit' }
  # Create respitory on github. This requires Hub [https://github.com/github/hub]
  # run 'git create'
  run("vsc")
end
