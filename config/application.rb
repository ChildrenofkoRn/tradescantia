require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
Dotenv::Railtie.load

module Tradescantia
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    config.exceptions_app = ->(env) {
      ErrorsController.action(:show).call(env)
    }

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = "Indian/Antananarivo"
    # config.eager_load_paths << Rails.root.join("extras")
    #
    config.active_job.queue_adapter = :sidekiq

    config.generators do |gen|
      gen.test_framework :rspec,
                         controller_specs: true,
                         view_specs: false,
                         helper_specs: false,
                         routing_specs: false,
                         request_specs: false

      gen.stylesheets = false
      gen.javascripts = false
    end
  end
end
