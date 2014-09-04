# config valid only for Capistrano 3.1
lock '3.2.1'
set :stages, %w(testing production) 
set :default_stage, "production" 
require 'capistrano/ext/multistage'

set :application, 'ttmate_test3'
set :repo_url, 'git@github.com:BalainGitHub/ttmate_test3.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/var/www/ttmate_test3'

# Default value for :scm is :git
set :scm, :git

set :user, "ec2-user"

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

desc "check production task" 
  task :check_production do 
    if stage.to_s == "production" 
      puts " \n Are you REALLY sure you want to deploy to production?" 
      puts " \n Enter the password to continue\n " 
      password = STDIN.gets[0..7] rescue nil 
      if password != 'mypasswd' 
        puts "\n !!! WRONG PASSWORD !!!" 
        exit 
      end 
    end 
  end

role :web, "ec2-54-191-49-126.us-west-2.compute.amazonaws.com" # Your HTTP server, Apache/etc 
role :app, "ec2-54-191-49-126.us-west-2.compute.amazonaws.com" # This may be the same as your `Web` server

before "deploy", "check_production"

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
