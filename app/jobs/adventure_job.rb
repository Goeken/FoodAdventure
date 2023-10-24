# frozen_string_literal: true

class AdventureJob < ApplicationJob
  queue_as :default

  def perform(adventure_id)
    adventure = Adventure.find(adventure_id)
    SmsService.send_sms(
      adventure.phone_number,
      "🎉 Your Food Truck Adventure has begun! First stop: #{adventure.next_truck.applicant} at #{adventure.next_truck.address}, #{adventure.next_truck.city}, #{adventure.next_truck.state}. Let's roll! 🚚 Type 'next' when you're ready for the next stop, or 'stop' to end your adventure."
    )
  end
end
