require "openai"

begin
  # Try to access the credentials
  api_key = Rails.application.credentials.openai.access_key
  Rails.logger.info "OpenAI API key present: #{api_key.present?}"
  Rails.logger.info "OpenAI API key length: #{api_key&.length}"
  Rails.logger.info "First few characters of key: #{api_key&.slice(0..3)}..."
rescue => e
  Rails.logger.error "Error accessing OpenAI credentials: #{e.message}"
end

OpenAI.configure do |config|
  config.access_token = api_key

  if config.access_token.blank?
    Rails.logger.error "OpenAI API key is not configured!"
  else
    Rails.logger.info "OpenAI client configured with key starting with: #{config.access_token.slice(0..3)}..."
  end
end
