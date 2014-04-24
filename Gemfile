source 'http://rubygems.org'

ruby '2.0.0'

gem 'rails','3.2.15'

gem 'pg',                               '~> 0.15.1'
gem 'haml',                             '~> 4.0.2'
gem 'twitter-bootstrap-rails',          '~> 2.2.6'
gem 'devise',                           '~> 2.2.3'
gem 'devise-async'
gem 'cancan',                           '~> 1.6.8'
gem 'aws-sdk',                          '~> 1.9.3'
gem 'daemons',                          '~> 1.1.9'
gem 'stripe',                           '~> 1.8.1'
gem 'truncate_html',                    '~> 0.9.2'
gem 'activerecord-postgresql-adapter',  '~> 0.0.1'
gem 'oauth2',                           '~> 0.8.1'
gem 'omniauth',                         '~> 1.1.4'
gem 'omniauth-facebook',                '~> 1.4.1'
gem 'omniauth-twitter',                 '~> 0.0.16'
gem 'omniauth-linkedin',                '~> 0.1.0'
gem 'kaminari',                         '~> 0.14.1'
gem 'bitly',                            '~> 0.9.0'
gem 'filepicker-rails',                 '~> 0.0.2'
# gem 'heroku'
gem 'has_scope',                        '~> 0.5.1'
gem 'youtube_it',                       '~> 2.2.1'
gem 'rails_config',                     '~> 0.3.3'
gem 'newrelic_rpm',                     '~> 3.6.3.111'
gem 'meta_request',                     '~> 0.2.8'
gem 'airbrake',                         '~> 3.1.14'
gem 'prawn',                            '~> 0.12.0'
gem 'writeexcel',                       '~> 1.0.3'
gem 'activeadmin',                      '~> 0.6.2'
gem 'ssl_requirement',                  '~> 0.1.0'
gem 'jquery-rails',                     '~> 2.2.1'
gem 'unicorn',                          '~> 4.6.2'
gem 'capistrano',                       '~> 2.15.4'
gem 'mini_magick',                      '~> 3.5.0'
gem 'activemerchant',                   '~> 1.32.1', :require => 'active_merchant'
gem 'simple_form',                      '~> 2.1.0'
gem 'wicked',                           '~> 0.6.0'
gem 'validates_email_format_of',        '~> 1.5.3'
gem 'merit',                            '~> 1.6.1'
gem 'sidekiq',                          '~> 2.12.4'
gem 'whenever',                         '~> 0.8.2'
gem 'slim',                             '>= 1.1.0'
gem 'sinatra',                          '>= 1.3.0', :require => nil
gem 'redis',                            '~> 3.0.4'

group :assets do
  gem 'sass-rails',                     '~> 3.2.3'
  gem 'coffee-rails',                   '~> 3.2.1'
  gem 'uglifier',                       '>= 1.0.3'
  gem 'yui-compressor'
end

group :production do
  gem 'sass-rails',                     '~> 3.2.3'
  gem 'exception_notification'
  gem 'dotenv-deployment'
end

group :staging do
  gem 'erb2haml',                       '~> 0.1.5'
  gem 'rb-fsevent',                     '~> 0.9.1'
  gem 'rails-dev-boost', :git => 'git://github.com/thedarkone/rails-dev-boost.git'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'rails_best_practices'
end

group :development, :test do
  gem 'erb2haml',                       '~> 0.1.5'
  gem 'rb-fsevent',                     '~> 0.9.1'
  gem 'rails-dev-boost', :git => 'git://github.com/thedarkone/rails-dev-boost.git'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'rails_best_practices'
  gem 'debugger',                       '~> 1.6.6'
  gem 'cucumber-rails',                 '~> 1.3.1', :require => false
  # gem 'jasmine'
  # gem 'jasmine-rails'
  # gem 'jasminerice'
  gem 'launchy',                        '~> 2.3.0'
  gem 'dotenv-rails',                   '~> 0.9.0'
end

group :test do
  gem 'rspec',                          '~> 2.14.1'
  gem 'rspec-rails',                    '~> 2.14.0'
  gem 'capybara',                       '~> 2.1.0'
  gem 'selenium-webdriver',             '~> 2.38.0'
  gem 'capybara-webkit',                '~> 1.1.0'
  gem 'poltergeist',                    '~> 1.5.0'
  gem 'rack_session_access',            '~> 0.1.1'
  gem 'factory_girl_rails',             '~> 4.2.1'
  gem 'database_cleaner',               '~> 1.0.1'
  gem 'email_spec',                     '~> 1.5.0'
  gem 'ci_reporter',                    '~> 1.9.0'
  gem 'ffaker',                         '~> 1.22.1'
  gem 'webmock',                        '~> 1.16.0'
end
