# Rename

This gem allows you to rename your Rails application by using a single command.

Tested up to Ruby 3.4.5 and Rails 8.0.2

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rename'
```

## Usage

```
rails g rename:into New-Name
```

## Applied

```
Search and replace exact module name to...
  Gemfile
  Gemfile.lock
  README.md
  Rakefile
  config.ru
  config/application.rb
  config/boot.rb
  config/environment.rb
  config/environments/development.rb
  config/environments/production.rb
  config/environments/test.rb
  config/importmap.rb
  config/initializers/assets.rb
  config/initializers/content_security_policy.rb
  config/initializers/filter_parameter_logging.rb
  config/initializers/inflections.rb
  config/initializers/permissions_policy.rb
  config/puma.rb
  config/routes.rb
  config/deploy.yml (Rails 8)
  app/views/layouts/application.html.erb
  app/views/layouts/application.html.haml
  app/views/layouts/application.html.slim
  app/views/pwa/manifest.json.erb (Rails 8)
  README.md
  README.markdown
  README.mdown
  README.mkdn
  Dockerfile (if present)
Search and replace underscore seperated module name to...
  config/initializers/session_store.rb (if present)
  config/database.yml
  config/database.yml (Rails 8 multi-db: cache, queue, cable)
  config/database.yml (environment variables)
  config/cable.yml
  config/environments/production.rb
  config/deploy.yml (Rails 8 Kamal service names)
  package.json
Removing references...
  .idea
Renaming directory...
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
