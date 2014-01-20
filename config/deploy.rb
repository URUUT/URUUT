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


server '192.34.58.42', :app, :web, :db, :primary => true
set :bundle_flags, '--deployment --quiet --binstubs'

namespace :db do
  task :db_config, :except => { :no_release => true }, :role => :app do
    run "cp -f #{shared_path}/system/database.yml #{release_path}/config/database.yml"
  end
end

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      #monkey path
      run "#{sudo} /etc/init.d/bk_development stop"
      run "#{sudo} rm -f /var/run/bk_development/bk_development.pid"
      run "#{sudo} /etc/init.d/bk_development start"
    end
  end

  desc "reload the database with seed data"
  task :seed do
    run "cd #{current_path}; rake db:seed RAILS_ENV=#{rails_env}"
  end

  desc "Clear Tmp folder"
  task :seed do
    run "cd #{current_path}; rake tmp:clear RAILS_ENV=#{rails_env}"
  end


  desc "Change File Permissions on Temp folder"
  task :change_file_permission do
    run "cd #{current_path}; #{sudo} chmod -R 777 tmp/"
  end

  desc "Install new gems if Gemfile's updated"
  task :bundle_install do
    run "cd #{current_path}; bundle install"
  end
end

after "deploy:finalize_update", "db:db_config"
after "deploy", "deploy:migrate", "deploy:seed", "deploy:change_file_permission",
      "deploy:bundle_install"
