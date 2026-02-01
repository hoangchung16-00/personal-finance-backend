# config/initializers/cors.rb
begin
  require 'rack/cors'
rescue LoadError
  Rails.logger.warn "rack-cors not available - skipping CORS middleware setup"
else
  Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins ENV.fetch('CORS_ORIGIN', 'http://localhost:4200')
      resource '*',
        headers: :any,
        expose: ['access-token', 'expiry', 'token-type', 'uid', 'client'],
        methods: %i[get post put patch delete options head]
    end
  end
end