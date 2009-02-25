set :domain,      "snarky.umlatte.com"
role :web, domain
role :app, domain
role :db,  domain, :primary => true

set :application,   "isitspringyet"
set :deploy_to,     "/home/deploy/public_html/#{application}"

set :user,          'deploy'
set :group,         'users'

set :repository,            "git@github.com:r38y/isitspringyet.git"
set :scm,                   "git"
set :branch,      "master"

ssh_options[:keys]          = %w(/Users/randy/.ssh/id_rsa)
ssh_options[:port]          = 4392
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup"

namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
end