require_relative 'boot'
require "rails/all"


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Medstat
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.i18n.default_locale = :ru
    config.assets.precompile += %w( application.css application.js )
    config.assets.paths << Rails.root.join("app", "assets", "fonts")
    config.exceptions_app = self.routes

  end


end
