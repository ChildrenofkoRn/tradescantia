# config valid for current version and patch releases of Capistrano
lock "~> 3.17.2"

set :application, "tradescantia"
set :repo_url, "git@github.com:ChildrenofkoRn/tradescantia.git"

# Default branch is :master
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name

set :rvm_type , :user
set :rvm_ruby_version, "3.1.4@#{fetch(:application)}"
# or
# set :rvm_ruby_version, ENV['GEM_HOME'].gsub(/.*\//,'')

# fix: 'ERR_OSSL_EVP_UNSUPPORTED' when compiling packs with the latest node.js
# its also a good idea to add this ENV directly to the ~/.bash_profile on deploy server
set :default_env, {
  'NODE_OPTIONS' => '--openssl-legacy-provider',
}

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, "config/master.key", ".env", "config/database.yml",
                      "config/mailer.yml", "config/sidekiq.yml"

       # Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "tmp/webpacker",
                     "public/system", "vendor", "storage", "node_modules", "db/sphinx"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 12

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

# Uploads configs/envs/master.key
set :samples, %w(config/database.yml.sample config/mailer.yml.sample config/sidekiq.yml.sample .env.sample)

before "deploy:check:linked_files", :upload_files do
  invoke 'uploads:master_key'
  invoke 'uploads:samples'
end

# Sphinx
before "deploy:publishing", "sphinx:stop"
after "deploy:published", "sphinx:configure"
after "deploy:published", "sphinx:restart"

# Puma
after "deploy:published", "puma:reload"

# add sidekiq as systemd service
# cap production sidekiq:restart
set :init_system, :systemd
set :service_unit_name, "sidekiq"
