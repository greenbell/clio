require "bundler/capistrano"

set :application, "clio"
set :repository,  "git://github.com/greenbell/clio.git"
set :scm, :git
set :use_sudo, false

role :web, "clio@192.168.11.197"
role :app, "clio@192.168.11.197"
role :db, "clio@192.168.11.197", :primary => true
set :gateway, "clio@180.211.76.102"
set :ssh_options, {
  :auth_methods => %w(publickey)
}

set :default_environment, {
  'PATH' => "/opt/ruby-2.0.0-p247/bin:$PATH"
}

set :deploy_to, "/var/www/clio/clio/"
namespace :deploy do
  task :start do
    run "service unicorn_clio_clio start" 
  end
  task :stop do
    run "service unicorn_clio_clio stop"
  end
  task :restart do
    run "service unicorn_clio_clio restart"
  end
end
after "deploy:create_symlink" do
  run "ln -nfs #{shared_path}/config/mongoid.yml #{latest_release}/config/mongoid.yml"
end
