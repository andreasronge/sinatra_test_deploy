require 'rubygems'
require 'sinatra'

root_dir = File.join(File.dirname(__FILE__), "lib")
$LOAD_PATH.unshift root_dir
require 'hello'

set :environment, :production
set :root,  root_dir
set :app_file, File.join(root_dir, 'hello.rb')
disable :run

FileUtils.mkdir_p 'log' unless File.exists?('log')
log = File.new("log/sinatra.log", "a")
$stdout.reopen(log)
$stderr.reopen(log)

run Sinatra::Application