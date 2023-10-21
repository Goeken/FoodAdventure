require 'rails_helper'

RSpec.describe Adventure, type: :model do
  it { should validate_presence_of(:phone_number) }
  it { should validate_presence_of(:food_preference) }
  it { should validate_presence_of(:city) }
  it { should validate_presence_of(:state) }
  it { should validate_presence_of(:zip_code) }
  it { should validate_presence_of(:number_of_trucks) }
  it { should validate_presence_of(:adventure_day) }
  it { should validate_presence_of(:adventure_start_time) }

  it { should allow_value('1234567890').for(:phone_number) }
  it { should_not allow_value('123456789').for(:phone_number) }

  it { should validate_length_of(:state).is_equal_to(2) }

  it { should allow_value('12345').for(:zip_code) }
  it { should allow_value('12345-6789').for(:zip_code) }
  it { should_not allow_value('1234').for(:zip_code) }

  it { should validate_numericality_of(:number_of_trucks).is_greater_than_or_equal_to(1) }
  it { should_not allow_value(0).for(:number_of_trucks) }
  it { should define_enum_for(:status).with_values(in_progress: 0, complete: 1, stopped: 2, abandoned: 3) }
end
