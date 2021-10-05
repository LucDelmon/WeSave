# frozen_string_literal: true

# class Rental
#
# Holds the information regarding a car rental

class Rental
  FIRST_DISCOUNT = 0.9.freeze
  SECOND_DISCOUNT = 0.7.freeze
  THIRD_DISCOUNT = 0.5.freeze
  COMMISSION_RATE = 0.3.freeze
  ASSISTANCE_PRICE = 100.freeze

  attr_reader :car, :duration, :distance
  
  # @param rental_hash [Hash]
  # @param cars [Hash]
  def initialize(rental_hash:, cars:)
    @car = cars[rental_hash['car_id']]
    @duration = day_duration(
     start_date: Date.parse(rental_hash['start_date']), 
     end_date: Date.parse(rental_hash['end_date'])
   )  
    @distance = rental_hash['distance']
  end

  # @return [Integer]
  def price
    @price ||= duration_price + distance_price
  end

  # @return [Commission]
  def commission
    @commission ||= Commission.new(self)
  end

   # @return [Integer]
  def owner_part
    price - commission.full_fee
  end
  
  private

  # @param start_date [Date]
  # @param end_date [Date]
  # @return [Integer]
  def day_duration(start_date:, end_date:)
    (end_date - start_date).to_i + 1
  end

  # @return [Integer]
  def distance_price
    distance * car.price_per_km
  end

  # @return [Integer]
  def duration_price
    price_factor = case duration 
      when 1
        1
      when 2..4
        1 + FIRST_DISCOUNT*(duration-1)
      when 5..10
        1 + FIRST_DISCOUNT*3 + SECOND_DISCOUNT*(duration-4)
      when 10..Float::INFINITY
        1 + FIRST_DISCOUNT*3 + SECOND_DISCOUNT*6 + THIRD_DISCOUNT*(duration-10)
    end
    (car.price_per_day * price_factor).round(half: :up) 
  end
end