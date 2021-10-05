# frozen_string_literal: true

class BaseService

  # @param input_file [String]
  def initialize(input_file)
    input = JSON.parse(input_file)
    @cars = get_cars(input["cars"])
    @rentals = get_rentals(input["rentals"])
  end

  # @return [Array]
  def call
    raise NotImplementedError
  end

  private

  # @param cars_array [Array]
  # @return [Hash]
  def get_rentals(rentals_array)
    rentals_array.map { |r| [r['id'], Rental.new(rental_hash: r, cars: @cars)] }.to_h
  end

  # @param cars_array [Array]
  # @return [Hash]
  def get_cars(cars_array)
    cars_array.map { |c| [c['id'], Car.new(c)] }.to_h
  end
end
