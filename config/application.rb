require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
# require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Clio
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = "Tokyo"

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.servers = lambda { |session|
      case session
      when nil
        [
          "gateway1",
          "gateway2",
          "admin1",
          "admin2",
          "web3",
          "web4",
          "web5",
          "my-style-api1",
          "my-style-api2",
          "mail1",
          "mail2",
          "night-admin",
          "night-admin2",
          "night-web1",
          "night-web2",
          "night-web3",
          "night-web4",
          "night-style-api1",
          "night-style-api2",
          "proxy1",
          "proxy2",
          "night-proxy1",
          "night-proxy2",
          "master1",
          "master2",
          "slave3",
          "slave4",
          "slave5",
          "slave6",
          "slave7",
          "slave8"
        ]
      when "staging"
        [
          "staging-proxy",
          "staging-admin",
          "staging-gateway",
          "staging-web",
          "staging-web2",
          "staging-master",
          "staging-slave"
        ]
      when "nightly"
        [
          "nightly-ns",
          "nightly-my",
          "nightly-night",
          "nightly-img",
          "nightly-nsorg"
        ]
      end
    }
  end
end
