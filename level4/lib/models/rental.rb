# frozen_string_literal: true

# class Rental
#
# Holds the information regarding a car rental

class Rental
  FIRST_DISCOUNT = 0.9.freeze
  FIRST_DISCOUNT_START = 1.freeze
  SECOND_DISCOUNT = 0.7.freeze
  SECOND_DISCOUNT_START = 5.freeze
  THIRD_DISCOUNT = 0.5.freeze
  THIRD_DISCOUNT_START = 11.freeze

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
    price_factor = rental_day_in_range(1..FIRST_DISCOUNT_START - 1) + 
      FIRST_DISCOUNT * rental_day_in_range(FIRST_DISCOUNT_START..SECOND_DISCOUNT_START - 1) + 
        SECOND_DISCOUNT * rental_day_in_range(SECOND_DISCOUNT_START..THIRD_DISCOUNT_START - 1) +
          THIRD_DISCOUNT * rental_day_in_range(THIRD_DISCOUNT_START..Float::INFINITY) 

    (car.price_per_day * price_factor).round(half: :up) 
  end

  # @return [Integer]
  def rental_day_in_range(range)
    if range.end == Float::INFINITY
      days = @duration - range.begin + 1
      days.positive? ? days : 0
    else
      range.to_a.intersection((0..@duration).to_a).size
    end
  end
end
