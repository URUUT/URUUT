source 'http://rubygems.org'

gem 'rails','3.2.11'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'
 
# gem "mongoid", ">= 3.0.14"
gem 'paperclip', '~>3.1.3'
gem 'delayed_paperclip'
gem 'haml'
gem "twitter-bootstrap-rails"
gem 'devise'
gem 'aws-sdk'
gem 'delayed_job_active_record'
gem "daemons"
gem "bootstrap-wysihtml5-rails"
gem "stripe"
gem "truncate_html"
gem "activerecord-postgresql-adapter"
gem "oauth2"
gem "omniauth"
gem "omniauth-facebook"
gem "kaminari"
gem "bitly"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

group :production do
  gem "mysql2", "~> 0.3.11"
  gem 'sass-rails',   '~> 3.2.3'
end

group :development, :test do
  gem "mysql2", "~> 0.3.11"
  gem "erb2haml"
  gem 'rb-fsevent', '~> 0.9.1'
  gem 'rails-dev-boost', :git => 'git://github.com/thedarkone/rails-dev-boost.git', :require => 'rails_development_boost'
  gem "better_errors"
  gem "binding_of_caller"
  gem "rails_best_practices"
end

gem 'jquery-rails'

# Use unicorn as the app server
gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano'
