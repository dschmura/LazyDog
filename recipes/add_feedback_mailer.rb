# CREATE MODEL TO HANDLE VALIDATIONS
rails_command("g model Feedback --skip-migration")

# ADD ROUTES
insert_into_file 'config/routes.rb', before: 'end' do
  <<-FEEDBACK_ROUTE
  resources 'feedbacks', only: [:create]
  FEEDBACK_ROUTE
end

# GENERATE MAILER

rails_command('g mailer Feedback')

# # SETUP ENVIRONMENTS FOR mailer
# insert_into_file 'config/environments/development.rb', after: 'Rails.application.configure do' do
#   <<-DEVELOPMENT_ENVIRONMENT
#
#   config.action_mailer.delivery_method = :letter_opener
#
#   DEVELOPMENT_ENVIRONMENT
# end

# insert_into_file 'config/environments/staging.rb', after: 'Rails.application.configure do' do
#   <<-STAGING_ENVIRONMENT

#   config.action_mailer.delivery_method = :sendmail
#   config.action_mailer.perform_deliveries = true
#   config.action_mailer.default_options = {from: 'mi.locations.feedback@umich.edu'}

#   config.action_mailer.smtp_settings = {address: "app_name}
#   config.action_mailer.smtp_settings = {
#     address: Rails.application.credentials.staging_mail[:STANDARDRB_EMAIL_SERVER],
#     domain: Rails.application.credentials.staging_mail[:STANDARDRB_EMAIL_DOMAIN],
#     user_name: Rails.application.credentials.staging_mail[:STANDARDRB_EMAIL_USERNAME],
#     password: Rails.application.credentials.staging_mail[:STANDARDRB_EMAIL_PASSWORD],
#     authentication: :login,
#     enable_starttls_auto: "true",
#     port: "587",
#   }

#   STAGING_ENVIRONMENT
# end

insert_into_file 'config/environments/production.rb', after: 'Rails.application.configure do' do
  <<-PRODUCTION_ENVIRONMENT

  config.action_mailer.delivery_method = :sendmail
  config.action_mailer.perform_deliveries = true
  config.action_mailer.default_options = {from: 'mi.locations.feedback@umich.edu'}

  config.action_mailer.smtp_settings = {address: "app_name"}
  config.action_mailer.smtp_settings = {
    address: Rails.application.credentials.production_mail[:STANDARDRB_EMAIL_SERVER],
    domain: Rails.application.credentials.production_mail[:STANDARDRB_EMAIL_DOMAIN],
    user_name: Rails.application.credentials.production_mail[:STANDARDRB_EMAIL_USERNAME],
    password: Rails.application.credentials.production_mail[:STANDARDRB_EMAIL_PASSWORD],
    authentication: :login,
    enable_starttls_auto: "true",
    port: "587",
  }

  PRODUCTION_ENVIRONMENT
end

# ALLOW SCRIPTS TO BE LOADED ON HTTP (LESS SECURE)
print
"there's a new initializer called content_security_policy.rb - in there you'll find a line like this:\n
.script_src :self, :https\n
\n
change it to:\n
\n
p.script_src :self, :https, :unsafe_inline\n"

# Add modal dependency
run "yarn add tailwindcss-stimulus-components"

append_to_file 'app/javascript/controllers/index.js' do
  <<-TAILWINDS_STIMULUS_COMPONENTS

  // Import and register all TailwindCSS Components
  import { Dropdown, Modal, Tabs, Popover } from "tailwindcss-stimulus-components"
  application.register('dropdown', Dropdown)
  application.register('modal', Modal)
  application.register('tabs', Tabs)
  application.register('popover', Popover)

  TAILWINDS_STIMULUS_COMPONENTS
end

gsub_file('app/views/layouts/application.html.haml',  '= debug(params) if Rails.env.development?', '')
gsub_file('app/views/layouts/application.html.haml',  "= render 'layouts/footer'", '')

append_to_file "app/views/layouts/application.html.haml" do
  <<-FEEDBACK_MODAL

  - unless action_name == 'contact'
    = render 'feedback/feedback_modal'
  = debug(params) if Rails.env.development?
  = render 'layouts/footer'


  FEEDBACK_MODAL
end
