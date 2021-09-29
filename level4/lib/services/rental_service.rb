# frozen_string_literal: true

# class RentalService
#
# Compute rental prices
class RentalService
  FIRST_DISCOUNT = 0.9.freeze
  SECOND_DISCOUNT = 0.7.freeze
  THIRD_DISCOUNT = 0.5.freeze
  COMMISSION_RATE = 0.3.freeze
  ASSISTANCE_PRICE = 100.freeze

  # @param input_file [String]
  def initialize(input_file)
    input = JSON.parse(input_file)
    @cars = input["cars"].map { |c| [c['id'], c] }.to_h
    @rentals = input["rentals"]
  end

  # @return [Array]
  def call
    @rentals.map do |rental| 
      car = @cars[rental['car_id']]
      rental_price = rental_price(car: car, rental: rental)
      owner_part = (rental_price * (1 - COMMISSION_RATE)).round(half: :down)
      commission = detailled_commission(rental_price: rental_price, rental: rental)
      { id: rental['id'], price: rental_price, owner_part: owner_part, commission: commission }
    end
  end

  private

  # @return [Integer] the rental duration in days
  def rental_duration(rental)
    (Date.parse(rental['end_date']) - Date.parse(rental['start_date'])).to_i + 1
  end

  # @param car [Hash]
  # @param rental [Hash]
  # @return [Integer]
  def rental_price(car:, rental:)
    duration_price(car: car, rental: rental) + distance_price(car: car, rental: rental)
  end

  # @param car [Hash]
  # @param rental [Hash]
  # @return [Integer]
  def distance_price(car:, rental:)
    rental['distance'] * car['price_per_km']
  end


  # @param car [Hash]
  # @param rental [Hash]
  # @return [Integer]
  def duration_price(car:, rental:)
    rental_duration = rental_duration(rental)
    price_factor = case rental_duration 
      when 1
        1
      when 2..4
        1 + FIRST_DISCOUNT*(rental_duration-1)
      when 5..10
        1 + FIRST_DISCOUNT*3 + SECOND_DISCOUNT*(rental_duration-4)
      when 10..Float::INFINITY
        1 + FIRST_DISCOUNT*3 + SECOND_DISCOUNT*6 + THIRD_DISCOUNT*(rental_duration-10)
    end
    (car['price_per_day'] * price_factor).round(half: :up) 
  end

  # @param rental_price [Integer]
  # @param rental [Hash]
  # @return [Hash]
  def detailled_commission(rental_price:, rental:)
    full_commission = rental_price * COMMISSION_RATE
    assistance_fee = rental_duration(rental) * ASSISTANCE_PRICE
    insurance_fee = (full_commission/2).round(half: :down)
    drivy_fee =  (full_commission - assistance_fee - insurance_fee).round(half: :up)
    { 'insurance_fee': insurance_fee, 'assistance_fee': assistance_fee, 'drivy_fee': drivy_fee }
  end
end
