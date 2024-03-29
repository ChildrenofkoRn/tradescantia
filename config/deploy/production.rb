# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

# server "example.com", user: "deploy", roles: %w{app db web}, my_property: :my_value
# server "example.com", user: "deploy", roles: %w{app web}, other_property: :other_value
# server "db.example.com", user: "deploy", roles: %w{db}

set :env_file, "config/deploy/deploy_#{fetch(:stage)}.env"

Dotenv.load(fetch(:env_file)) if Checker.exist?(fetch(:env_file))

server ENV["DEPLOY_HOST"], user: ENV["DEPLOY_USER"], roles: %w{app db web}, primary: :true
set :rails_env, :production
set :bundle_without, %w{ development test staging }.join(':')

set :deploy_to, ENV["DEPLOY_PATH"]
set :deploy_user, ENV["DEPLOY_USER"]

# set :rvm_ruby_version, :local
# set :rvm_ruby_version, "."
# set :rvm_ruby_version, "3.4.1@#{fetch(:application)}"
# set :rvm_ruby_string, "3.4.1@#{fetch(:application)}" # you probably have this already
# set :rvm_type, :user

# role-based syntax
# ==================

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.

# role :app, %w{deploy@example.com}, my_property: :my_value
# role :web, %w{user1@primary.com user2@additional.com}, other_property: :other_value
# role :db,  %w{deploy@example.com}



# Configuration
# =============
# You can set any configuration variable like in config/deploy.rb
# These variables are then only loaded and set in this stage.
# For available Capistrano configuration variables see the documentation page.
# http://capistranorb.com/documentation/getting-started/configuration/
# Feel free to add new variables to customise your setup.



# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult the Net::SSH documentation.
# http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/user_name/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# The server-based syntax can be used to override options:
# ------------------------------------
# server "example.com",
#   user: "user_name",
#   roles: %w{web app},
#   ssh_options: {
#     user: "user_name", # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: "please use keys"
#   }

set :ssh_options, {
  keys: ENV["DEPLOY_SSH_KEYS"].split(',').map(&:strip) + %w(/home/user/.ssh/someKeys),
  forward_agent: true,
  auth_methods: %w(publickey password),
  port: ENV["DEPLOY_SSH_PORT"]
}
