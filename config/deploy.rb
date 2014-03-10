require 'bundler/capistrano'

set :application, 'techbridge'

#git
set :repository, 'git@github.com:URUUT/URUUT.git'
set :branch, 'techbridge'
set :scm, :git

#path
set :deploy_to, "/u/apps/#{application}"

set :user,      'deploy'
set :password,  'qwerty1000'
set :use_sudo,  false
default_run_options[:pty] = true

set :keep_releases, 5

server '192.34.58.42', :app, :web, :db, :primary => true
set :bundle_flags, '--deployment --quiet --binstubs'

set :default_environment, {
  'PATH' => "/home/#{user}/.rbenv/shims:/home/#{user}/.rbenv/bin:$PATH",
  'REDISTOGO_URL' => 'redis://localhost:6379/'
}

namespace :db do
  task :db_config, :except => { :no_release => true }, :role => :app do
    run "cp -f #{shared_path}/system/database.yml #{release_path}/config/database.yml"
  end

  # task :load_schema, :except => { :no_release => true }, :roles => :app do
  #   run "cd #{release_path}; bundle exec rake db:schema:load RAILS_ENV=#{rails_env}"
  # end
end

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      #monkey path
      run "cd #{release_path};/etc/init.d/unicorn_techbridge stop"
      run "rm -f /u/apps/techbridge/shared/pids/unicorn.pid"
      run "cd #{release_path};/etc/init.d/unicorn_techbridge start"
    end
  end

  # desc "reload the database with seed data"
  # task :seed do
  #   run "cd #{release_path}; bundle exec rake db:seed RAILS_ENV=#{rails_env}"
  # end

  desc "Clear Tmp folder"
  task :seed do
    run "cd #{release_path}; bundle exec rake tmp:clear RAILS_ENV=#{rails_env}"
  end


  desc "Change File Permissions on Temp folder"
  task :change_file_permission do
    run "cd #{release_path}; #{sudo} chmod -R 777 tmp/"
  end

  desc "Install new gems if Gemfile's updated"
  task :bundle_install do
    run "cd #{release_path}; bundle install"
  end

  desc "Reload Nginx"
  task :reload_nginx do
      sudo "/etc/init.d/nginx reload"
  end
end

after "deploy:finalize_update", "db:db_config"
after "deploy", "deploy:migrate", "deploy:change_file_permission",
      "deploy:bundle_install", 'deploy:restart', 'deploy:reload_nginx'
