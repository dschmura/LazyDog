run 'mkdir .env'
run 'mkdir .env/development'
run 'mkdir .env/test'
run 'mkdir .env/staging'
run 'mkdir .env/production'
run 'mkdir .dockerenv'

create_file '.dockerenv/.bashrc' do
  <<~EOF
  alias be="bundle exec"
  EOF
end
create_file '.dockerenv/.psqlrc' do
  <<~EOF
  -- Don't display the "helpful" message on startup.
  \\set QUIET 1

  -- Allow specifying the path to history file via `PSQL_HISTFILE` env variable
  -- (and fallback to the default $HOME/.psql_history otherwise)
  \\set HISTFILE `[[ -z $PSQL_HISTFILE ]] && echo $HOME/.psql_history || echo $PSQL_HISTFILE`

  -- Show how long each query takes to execute
  \\timing

  -- Use best available output format
  \\x auto

  -- Verbose error reports
  \\set VERBOSITY verbose

  -- If a command is run more than once in a row,
  -- only store it once in the history
  \\set HISTCONTROL ignoredups
  \\set COMP_KEYWORD_CASE upper

  -- By default, NULL displays as an empty space. Is it actually an empty
  -- string, or is it null? This makes that distinction visible
  \\pset null '[NULL]'

  \\unset QUIET
  EOF
end

create_file '.dockerenv/Aptfile' do
  <<~EOF
  vim
  EOF
end

create_file '.env/development/web' do
  <<~EOF
  DATABASE_HOST=postgres
  EOF
end


create_file '.env/development/database' do
  <<~EOF
  POSTGRES_USER=postgres
  POSTGRES_DB=app_name_development
  POSTGRES_HOST=postgres
  POSTGRES_HOST_AUTH_METHOD=trust
  EOF
end

gsub_file 'config/webpacker.yml', 'host: localhost', "host: 0.0.0.0"

# By default, Ruby buffers output to stdout, which doesn’t play well with Compose.The fix to thisswitch off Ruby’s output buffering.

append_to_file 'config/boot.rb' do
  "$stdout.sync = true"
end

create_file '.dockerenv/Dockerfile' do
  <<~EOF
  ARG RUBY_VERSION
  FROM ruby:$RUBY_VERSION-slim-buster

  ARG PG_MAJOR
  ARG NODE_MAJOR
  ARG BUNDLER_VERSION
  ARG YARN_VERSION

  # Common dependencies
  RUN apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
      build-essential \
      gnupg2 \
      curl \
      less \
      git \
    && apt-get clean \
    && rm -rf /var/cache/apt/archives/* \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && truncate -s 0 /var/log/*log

  # Add PostgreSQL to sources list
  RUN curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && echo 'deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list

  # Add NodeJS to sources list
  RUN curl -sL https://deb.nodesource.com/setup_$NODE_MAJOR.x | bash -

  # Add Yarn to the sources list
  RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list

  # Install dependencies
  COPY .dockerenv/Aptfile /tmp/Aptfile
  RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
      libpq-dev \
      postgresql-client-$PG_MAJOR \
      nodejs \
      yarn=$YARN_VERSION-1 \
      $(cat /tmp/Aptfile | xargs) && \
      apt-get clean && \
      rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
      truncate -s 0 /var/log/*log
  # Configure bundler
  ENV LANG=C.UTF-8 \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

  # Uncomment this line if you store Bundler settings in the project's root
  # ENV BUNDLE_APP_CONFIG=.bundle

  # Uncomment this line if you want to run binstubs without prefixing with `bin/` or `bundle exec`
  ENV PATH /app/bin:$PATH

  # Upgrade RubyGems and install required Bundler version
  # See https://github.com/evilmartians/terraforming-rails/pull/24 for discussion
  RUN gem update --system && \
      rm /usr/local/lib/ruby/gems/*/specifications/default/bundler-*.gemspec && \
      gem uninstall bundler && \
      gem install bundler -v $BUNDLER_VERSION

  # Create a directory for the app code
  RUN mkdir -p /app

  WORKDIR /app

  COPY Gemfile /app/Gemfile
  COPY Gemfile.lock /app/Gemfile.lock
  COPY package.json /app/package.json
  COPY yarn.lock /app/yarn.lock
  RUN bundle install && yarn upgrade
  EOF
end

#  CREATE DOCKER-COMPOSE file
# https://www.rubidium.io/templates/docker-development-environment
create_file 'docker-compose.yml' do
  <<~EOF
  version: '2.4'

  x-app: &app
    build:
      context: .
      dockerfile: ./.dockerenv/Dockerfile
      args:
        RUBY_VERSION: '2.7.1'
        PG_MAJOR: '12'
        NODE_MAJOR: '14'
        YARN_VERSION: '1.22.4'
        BUNDLER_VERSION: '2.1.4'
    environment: &env
      NODE_ENV: ${RAILS_ENV:-development}
      RAILS_ENV: ${RAILS_ENV:-development}
    # image: example-dev:1.1.0
    tmpfs:
      - /tmp

  x-backend: &backend
    <<: *app
    stdin_open: true
    tty: true
    volumes:
      - .:/app:cached
      - rails_cache:/app/tmp/cache
      - bundle:/usr/local/bundle
      - node_modules:/app/node_modules
      - packs:/app/public/packs
      - .dockerenv/.psqlrc:/root/.psqlrc:ro
      - .dockerenv/.bashrc:/root/.bashrc:ro

    environment:
      <<: *env
      REDIS_URL: redis://redis:6379/
      DATABASE_URL: postgres://postgres:postgres@postgres:5432
      BOOTSNAP_CACHE_DIR: /usr/local/bundle/_bootsnap
      WEBPACKER_DEV_SERVER_HOST: webpacker
      WEB_CONCURRENCY: 1
      HISTFILE: /app/log/.bash_history
      PSQL_HISTFILE: /app/log/.psql_history
      EDITOR: vi
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy

  services:
    runner:
      <<: *backend
      command: /bin/bash
      ports:
        - '3000:3000'
        - '3002:3002'

    rails:
      <<: *backend
      command: if [ tmp/pids/server.pid ]; then rm  tmp/pids/server.pid; fi
      command: bundle exec rails server -b 0.0.0.0
      ports:
        - '3000:3000'

    sidekiq:
      <<: *backend
      command: bundle exec sidekiq -C config/sidekiq.yml

    postgres:
      image: postgres
      env_file:
        - .env/development/database
        - .env/development/web
      volumes:
        - .dockerenv/.psqlrc:/root/.psqlrc:ro
        - postgres:/var/lib/postgresql/data
        - ./log:/root/log:cached
        # - ./init.sql:/docker-entrypoint-initdb.d/init.sql
      environment:
        PSQL_HISTFILE: /root/log/.psql_history
      ports:
        - 5432
      healthcheck:
        test: pg_isready -U postgres -h 127.0.0.1
        interval: 5s

    redis:
      image: redis
      volumes:
        - redis:/data
      ports:
        - 6379
      healthcheck:
        test: redis-cli ping
        interval: 1s
        timeout: 3s
        retries: 30

    webpacker:
      <<: *app
      command: ./bin/webpack-dev-server
      ports:
        - '3035:3035'
      volumes:
        - .:/app:cached
        - bundle:/usr/local/bundle
        - node_modules:/app/node_modules
        - packs:/app/public/packs
      environment:
        <<: *env
        WEBPACKER_DEV_SERVER_HOST: 0.0.0.0

  volumes:
    postgres:
    redis:
    bundle:
    node_modules:
    rails_cache:
    packs:

  EOF
end

run 'rm config/database.yml'
create_file 'config/database.yml' do
  <<~EOF
  default: &default
    adapter: postgresql
    encoding: unicode
    host:     postgres
    username: postgres
    pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
    variables:
      statement_timeout: 5000

  development:
    <<: *default
    database: app_name_development

  test:
    <<: *default
    database: app_name_test

  staging:
    <<: *default
    database: app_name_staging

  production:
    <<: *default
    database: app_name_production

  EOF
end

append_to_file ".gitignore" do
  <<~EOF

# Ignore docker env for production and staging
.env/production
.env/staging
  EOF
end

create_file '.dockerignore' do
  <<~EOF
.DS_Store
.bin
.env
.git
.gitignore
.bundleignore
.bundle
.byebug_history
.rspec
tmp
log
test
config/deploy
public/packs
public/packs-test
node_modules
yarn-error.log
working_files/
  EOF
end

gsub_file 'config/database.yml', 'app_name', "#{app_name}"