require 'cucumber/formatter/unicode' # Remove this line if you don't want Cucumber Unicode support
require 'cucumber/rails/rspec'
require 'cucumber/rails/world'
require 'cucumber/rails/active_record'
require 'cucumber/web/tableish'

Webrat.configure do |config|
  config.mode = :selenium
  config.open_error_files = false # Set to true if you want error pages to pop up in the browser
  config.selenium_browser_startup_timeout = 10
#  config.application_environment = :external
end

# If you set this to false, any error raised from within your app will bubble
# up to your step definition and out to cucumber unless you catch it somewhere
# on the way. You can make Rails rescue errors and render error pages on a
# per-scenario basis by tagging a scenario or feature with the @allow-rescue tag.
#
# If you set this to true, Rails will rescue all errors and render error
# pages, more or less in the same way your application would behave in the
# default production environment. It's not recommended to do this for all
# of your scenarios, as this makes it hard to discover errors in your application.
ActionController::Base.allow_rescue = false

# If you set this to true, each scenario will run in a database transaction.
# You can still turn off transactions on a per-scenario basis, simply tagging
# a feature or scenario with the @no-txn tag. If you are using Capybara,
# tagging with @culerity or @javascript will also turn transactions off.
#
# If you set this to false, transactions will be off for all scenarios,
# regardless of whether you use @no-txn or not.
#
# Beware that turning transactions off will leave data in your database
# after each scenario, which can lead to hard-to-debug failures in
# subsequent scenarios. If you do this, we recommend you create a Before
# block that will explicitly put your database in a known state.
Cucumber::Rails::World.use_transactional_fixtures = true

# How to clean your database when transactions are turned off. See
# http://github.com/bmabey/database_cleaner for more info.
if defined?(ActiveRecord::Base)
  begin
    require 'database_cleaner'
    DatabaseCleaner.strategy = :truncation
  rescue LoadError => ignore_if_database_cleaner_not_present
  end
end

#Before do
#  selenium.execution_delay = 100
#end

module Webrat

  module Selenium
    module ApplicationServers
      class Rails < Webrat::Selenium::ApplicationServers::Base
        # Use the daemonize technique for MRI too, because mongrel_rails,
        # the way webrat normally tries to start rails, is not compatible with Rails 3.
        def start_command
          "#{rails} server --daemon " +
                          "--port=#{Webrat.configuration.application_port} " +
                          "--environment=#{Webrat.configuration.application_environment} " +
                          "--pid #{pid_file}"
        end

        def stop
          Process.kill('INT', IO.read(pid_file).to_i)
        end
      end
    end
  end
  
  class SeleniumSession

    protected

    def setup #:nodoc:
      Webrat::Selenium::SeleniumRCServer.boot
      Webrat::Selenium::ApplicationServerFactory.app_server_instance.boot

      create_browser
      $browser.start

      extend_selenium
      define_location_strategies
      # $browser.window_maximize
    end
  end

  module Selenium
    class SeleniumRCServer

      def jar_path_with_gem_check
        # See if we can find the selenium-rc gem
        selenium_rc_gem = Gem.source_index.gems.keys.grep(/^selenium-rc-/).last
        if selenium_rc_gem
          File.join(Gem.source_index.gems[selenium_rc_gem].full_gem_path, 'vendor', 'selenium-server.jar')
        else
          jar_path_without_gem_check
        end
      end

      alias_method_chain :jar_path, :gem_check

    end
  end
end
