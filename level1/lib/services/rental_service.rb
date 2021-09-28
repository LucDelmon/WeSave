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
   rental_duration * car['price_per_day'] + rental['distance'] * car['price_per_km']
  end
end

