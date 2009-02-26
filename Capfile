load 'deploy' if respond_to?(:namespace) # cap2 differentiator
# Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
# load 'config/deploy'

server 'isitspringyet.com', :web, :app
set :application,   "isitspringyet"
set :deploy_to,     "/home/deploy/public_html/#{application}"
set :user,          'deploy'
set :group,         'users'
set :use_sudo,      false
set :repository,    "git@github.com:r38y/isitspringyet.git"
set :scm,           "git"
ssh_options[:keys]  = %w(/Users/randy/.ssh/id_rsa)
ssh_options[:port]  = 4392
after "deploy", "deploy:cleanup"

namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
end