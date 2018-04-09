# LazyDog
LazyDog is my latest dive into creating a rails template that sets things up just so...

# Getting Started:

## Initial deployment

### Set up credentials

** From within the root of your new application

```
EDITOR=vim bin/rails credentials:edit
```

Here is a sample of what the app will need to add for your production deployment. Once you have finished, save the document and commit the changes.

```
production:
  APPNAME_WEBSITE_EMAIL_SERVER: secure.emailsrvr.com
  APPNAME_WEBSITE_EMAIL_DOMAIN: your_domain_name.com
  APPNAME_WEBSITE_EMAIL_USERNAME: your_email_username
  APPNAME_WEBSITE_EMAIL_PASSWORD: your_email_password
  PRODUCTION_DB_USERNAME: deployer
  PRODUCTION_DB_PASSWORD: your_database_password_or_blank
```


### Configure your deployment target(s)

Edit the config/deploy/production.rb and config/deploy/staging.rb to make sure the server is set correctly.

### Congfigure your config/nginx.sample.conf file

Change the server_name to be the addresses that should be responded to.
For example;

```
server_name appname.com appname.net  www.appname.com www.appname.net;
```


### Set up github

The assumption is that we will use GitHub and have the git hub library installed and configured. For more information on how to do this: [Hub by GitHub](https://github.com/github/hub)

** From within the root of your new application

```
 git create
 git add .
 git commit -m "UPDATE: Configurations for deployment."
 git push
```

# On the Server

Create the production database for the application
#### PostgreSQL

Next we need to setup our postgres user (also named "deployer" but different from our linux user named "deployer") and database:
```sh
server:~$  sudo su - postgres
server:~$ createdb -O deployer my_app_name_production # change "my_app_name" to your app's name which we'll also use later on
exit
```

Create the symlink for the application
```
server:~$  sudo ln -nfs /home/deployer/apps/APP_NAME/current/config/nginx.conf /etc/nginx/sites-enabled/APP_NAME-puma
```

### Setup initial deployment.

```
cap production deploy

cap production deploy:upload

cap production deploy
```
