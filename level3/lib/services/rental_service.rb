# frozen_string_literal: true

# class RentalService
#
# Compute rental prices
class RentalService
  FIRST_DISCOUNT = 0.9
  SECOND_DISCOUNT = 0.7
  THIRD_DISCOUNT = 0.5

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
      { id: rental['id'], price: rental_price(car: car, rental: rental) }
    end
  end

  private


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
    rental_duration = (Date.parse(rental['end_date']) - Date.parse(rental['start_date'])).to_i + 1
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
end
