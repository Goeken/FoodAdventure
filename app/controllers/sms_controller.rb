# frozen_string_literal: true

class SmsController < ApplicationController
  skip_before_action :verify_authenticity_token # Skip CSRF check for webhook requests
  before_action :validate_twilio_request, only: [:receive]

  def receive
    body = params['Body'].strip.downcase
    phone_number = params['From'].gsub(/\D/, '')
    adventure = Adventure.where(phone_number: phone_number).order(created_at: :desc).first

    if phone_number.length > 10
      phone_number = phone_number[-10..] # Remove country code by keeping only the last 10 digits
    end

    if adventure.nil?
      SmsService.send_sms(
        phone_number,
        "🕵️ Oops! It seems like there's no active adventure linked to this number #{phone_number}. Craving some culinary quests? Head over to https://food-truck-adventure-222aa5bc5600.herokuapp.com/ to cook up a new Food Truck Adventure! 🚚🌮"
      )
      return
    end

    response = SmsService.process_command(adventure, body)
    SmsService.send_sms(phone_number, response[:message])
  end

  private

  def validate_twilio_request
    twilio_signature = request.headers['HTTP_X_TWILIO_SIGNATURE']

    validator = Twilio::Security::RequestValidator.new(Rails.application.credentials.dig(:twilio, :auth_token))

    return if validator.validate(request.original_url, request.POST, twilio_signature)

    render plain: 'Unauthorized request', status: :unauthorized
  end
end
