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

insert_into_file 'config/environments/production.rb', after: 'Rails.application.configure do' do
  <<-PRODUCTION_ENVIRONMENT

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              Rails.application.credentials.#{app_name.upcase}_EMAIL_SERVER,
    domain:               Rails.application.credentials.#{app_name.upcase}_EMAIL_DOMAIN,
    user_name:            Rails.application.credentials.#{app_name.upcase}_EMAIL_USERNAME,
    password:             Rails.application.credentials.#{app_name.upcase}_EMAIL_PASSWORD,
    authentication:       :login,
    enable_starttls_auto: 'true',
    port:                 '587'
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
