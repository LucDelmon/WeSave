# frozen_string_literal: true

# class Commission
#
# contain the commission detail of a rental
class Commission
  COMMISSION_RATE = 0.3.freeze
  INSURANCE_RATE = 0.5.freeze
  ASSISTANCE_PRICE = 100.freeze

  attr_reader :insurance_fee, :assistance_fee, :drivy_fee, :full_fee

  # @params rental [Rental]
  def initialize(rental)
    @full_fee = (rental.price * COMMISSION_RATE).round(half: :up)
    @assistance_fee = rental.duration * ASSISTANCE_PRICE
    @insurance_fee = (full_fee * INSURANCE_RATE).round(half: :down)
    @drivy_fee = (full_fee - @assistance_fee - @insurance_fee).round(half: :up)
  end

  # @return [Hash]
  def to_h
    {
      insurance_fee: @insurance_fee,
      assistance_fee: @assistance_fee,
      drivy_fee: @drivy_fee,
    }
  end
end
