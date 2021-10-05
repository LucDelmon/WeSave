# frozen_string_literal: true

# class Car
#
# Represent a car
class Car
  attr_reader :price_per_day, :price_per_km

  # @param car_hash [Hash]
  def initialize(car_hash)
    @price_per_day = car_hash['price_per_day']
    @price_per_km = car_hash['price_per_km']
  end
end