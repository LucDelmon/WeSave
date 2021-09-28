# frozen_string_literal: true

# class RentalService
#
# Compute rental prices
class RentalService
    def initialize(input_file)
      input = JSON.parse(input_file)
      @cars = input["cars"].map { |c| [c['id'], c] }.to_h
      @rentals = input["rentals"]
    end

    # @return [Array]
    def call
      @rentals.map do |rental| 
        car = @cars[rental['car_id']]
        { id: rental['id'], price: rental_price(car, rental) }
      end
    end

  private

  # @return [Integer]
  def rental_price(car, rental)
    rental_duration = (Date.parse(rental['end_date']) - Date.parse(rental['start_date'])).to_i + 1
    duration_price(car, rental_duration) + rental['distance'] * car['price_per_km']
  end

  # @return [Integer]
  def duration_price(car, rental_duration)
    price_factor = case rental_duration 
      when 1
        1
      when 2..4
        1 + 0.9*(rental_duration-1)
      when 5..10
        1 + 0.9*3 + 0.7*(rental_duration-4)
      when 10..Float::INFINITY
        1 + 0.9*3 + 0.7*6 + 0.5*(rental_duration-10)
    end
    (car['price_per_day'] * price_factor).round(half: :up) 
  end
end
