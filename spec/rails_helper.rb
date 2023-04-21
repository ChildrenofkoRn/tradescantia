# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include FeatureHelpers, type: :feature
  config.include ControllerHelpers, type: :controller
  config.extend WithModel
  config.include OmniauthHelpers, type: :feature
  OmniAuth.config.test_mode = true
  config.include ApiHelpers, type: :request


  # Fix WARN Selenium [DEPRECATION] [:capabilities] The :capabilities parameter
  Capybara.register_driver :chrome_headless do |app|

    options = Selenium::WebDriver::Chrome::Options.new(
                args: %w[headless disable-gpu no-sandbox window-size=1440,900]
              )

    Capybara::Selenium::Driver.new(
      app,
      browser: :chrome,
      clear_session_storage: true,
      clear_local_storage: true,
      options: options
    )
  end

  # Selenium::WebDriver.logger.ignore(:browser_options)
  Capybara.javascript_driver = :chrome_headless
  Capybara.default_max_wait_time = 6

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  # config.use_transactional_fixtures = true

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
  #

  config.use_transactional_fixtures = true

  config.before(:suite) do
    ThinkingSphinx::Test.init
    ThinkingSphinx::Test.start(index: false)
  end

  config.after(:suite) do
    ThinkingSphinx::Test.stop
    FileUtils.rm_rf("#{Rails.root}/db/sphinx/test")
  end

  config.after(:all) do
    FileUtils.rm_rf("#{Rails.root}/tmp/storage")
  end

end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

# Sphinx startup debug
# class Riddle::ExecuteCommand
#
#   def self.call(command, verbose = true)
#     p command
#     new(command, verbose).call
#   end
#
# end
