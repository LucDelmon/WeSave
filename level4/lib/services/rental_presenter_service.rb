# frozen_string_literal: true

# class RentalPresenterService
#
# Compute rental prices
class RentalPresenterService < BaseService

  # @return [Array]
  def call
    @rentals.map do |id, rental| 
      { id: id, price: rental.price, owner_part: rental.owner_part, commission: rental.commission.to_h }
    end
  end
end
