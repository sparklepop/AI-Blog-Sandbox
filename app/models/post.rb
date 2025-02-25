class Post < ApplicationRecord
  # Add Active Storage attachment
  has_one_attached :generated_image
  has_rich_text :content
  
  validates :title, presence: true

  def generate_image
    return false unless image_prompt.present?
    
    Rails.logger.info "Starting image generation..."
    Rails.logger.info "Image prompt: #{image_prompt}"
    
    begin
      # First verify we have credentials
      api_key = Rails.application.credentials.openai&.access_key
      if api_key.blank?
        Rails.logger.error "OpenAI API key not found in credentials!"
        return false
      end
      
      client = OpenAI::Client.new(access_token: api_key)
      Rails.logger.info "OpenAI client created with API key starting with: #{api_key[0..4]}..."
      
      Rails.logger.info "Making API call to OpenAI..."
      Rails.logger.info "Using prompt: #{image_prompt}"
      
      response = client.images.generate(
        parameters: {
          prompt: image_prompt,
          n: 1,
          size: "1024x1024",
          response_format: "b64_json"  # Get the actual image data
        }
      )
      
      Rails.logger.info "API call completed. Full response: #{response.inspect}"
      Rails.logger.info "Response data: #{response['data'].inspect}"
      Rails.logger.info "First item in data: #{response.dig('data', 0).inspect}"
      
      base64_data = response.dig("data", 0, "b64_json")
      Rails.logger.info "Base64 data length: #{base64_data&.length}"
      Rails.logger.info "Base64 data preview: #{base64_data&.slice(0..100)}..."
      
      if base64_data.present?
        Rails.logger.info "Decoding base64 data..."
        begin
          # Decode the base64 image
          image_data = Base64.decode64(base64_data)
          Rails.logger.info "Decoded image data length: #{image_data.length} bytes"
          
          # Create a temp file with the image data
          temp_file = Tempfile.new(['generated_image', '.png'])
          temp_file.binmode
          temp_file.write(image_data)
          temp_file.rewind
          
          Rails.logger.info "Temp file created at: #{temp_file.path}"
          Rails.logger.info "Temp file size: #{File.size(temp_file.path)} bytes"
          
          # Attach the image to the post
          attachment = generated_image.attach(
            io: temp_file,
            filename: "generated_image_#{Time.current.to_i}.png",
            content_type: 'image/png'
          )
          
          Rails.logger.info "Image attachment result: #{attachment.inspect}"
          Rails.logger.info "Image successfully attached to post"
          true  # Return success
        rescue => e
          Rails.logger.error "Error processing image: #{e.message}"
          Rails.logger.error e.backtrace.join("\n")
          false  # Return failure
        end
      else
        Rails.logger.error "No image data in response"
        false  # Return failure
      end
    rescue OpenAI::Error => e
      Rails.logger.error "OpenAI API Error: #{e.message}"
      Rails.logger.error "Error type: #{e.class}"
      false
    rescue => e
      Rails.logger.error "General error: #{e.message}"
      Rails.logger.error "Backtrace: #{e.backtrace.join("\n")}"
      false
    ensure
        #clean up temp file
        temp_file&.close
        temp_file&.unlink
    end
  end
end
