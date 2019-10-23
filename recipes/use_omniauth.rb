gem 'omniauth-google-oauth2'
run "bundle install"

run "bundle exec rails generate model OmniAuthService user:references provider uid access_token access_token_secret refresh_token expires_at:datetime auth:text"

run "bundle exec rails g migration AddAvatarToUser avatar_url:string"

run "bundle exec rails db:migrate"

insert_into_file "app/models/user.rb", after: ":validatable" do
  <<-OMNI_AUTHABLE
, :omniauthable, omniauth_providers: [:google_oauth2]

has_many :omni_auth_services, dependent: :destroy

  OMNI_AUTHABLE
end

insert_into_file "config/routes.rb", after: "devise_for :users" do
  <<-UPDATE_ROUTES
  , controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  UPDATE_ROUTES
end

insert_into_file "config/initializers/devise.rb", after: "# config.parent_controller = 'DeviseController'\n" do
  <<-UPDATE_DEVISE_INITIALIZER

  config.omniauth :google_oauth2, Rails.application.credentials.google_client_id,  Rails.application.credentials.google_client_secret, scope: 'userinfo.email, userinfo.profile', prompt: 'select_account', image_aspect_ratio: 'square', image_size: 50, hd: %w(umich.edu lsa.umich.edu )

  UPDATE_DEVISE_INITIALIZER
end

run "annotate"