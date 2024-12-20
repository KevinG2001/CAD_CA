require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Backend
  class Application < Rails::Application
    config.load_defaults 8.0

    # CORS Configuration
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins 'http://51.20.79.27:3000'

        resource '*',
                 headers: :any,
                 methods: [:get, :post, :put, :patch, :delete, :options]
      end
    end

    config.autoload_lib(ignore: %w[assets tasks])
    config.api_only = true
  end
end
