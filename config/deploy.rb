$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.
require 'bundler/capistrano'

set :rvm_ruby_string, 'jruby-1.5.5'        # Or whatever env you want it to run in.
set :rvm_type, :user

set :application, "goodcred"
set :repository,  "git://github.com/andreasronge/sinatra_test_deploy.git"
set :scm, :git
#set :scm_username, "andreas"
set :branch, "master"

set :environment, "production" #development" #production"
set :deploy_to, "/home/ubuntu/cap-deploy"
set :user, 'ubuntu'
set :use_sudo, :false
server "goodcred.dyndns.org", :app

namespace :deploy do
  desc "Start Tomcat from a shutdown state"
  task :cold do
    start
  end

  desc "Stop a server running Tomcat"
  task :stop do
    run %Q[if [ -f #{current_path}/tmp/pids/#{application} ]; then kill -INT $(cat #{current_path}/tmp/pids/#{application}); else echo "no running server"; fi]
  end

  desc "Starts the Tomcat server"
  task :start do
    run "rm -f #{current_path}/log/*"
    #trinidad -e production --load daemon --daemonize ./trinidad.pid
    run "trinidad -e #{environment} --threadsafe -d #{current_path}  --load daemon --daemonize #{current_path}/tmp/pids/#{application}"
  end

  desc "Restarts a server running Tomcat"
  task :restart do
    stop
    start
  end
end
