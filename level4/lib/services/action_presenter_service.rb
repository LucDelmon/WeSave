# frozen_string_literal: true

# class ActionPresenterService
#
# Present an hash of detailled rental as a list of debit/credit actions
class ActionPresenterService

  # @param computed_rentals [Hash]
  def initialize(computed_rentals)
    @rentals = computed_rentals
  end

  # @return [Array]
  def call
    @rentals.map do |rental| 
      { id: rental[:id], actions: actions_list(rental) }
    end
  end
  
  private

  # @return [Array]
  def actions_list(rental)
    [
      add_debit(who: 'driver', amout: rental[:price]),
      add_credit(who: 'owner', amout: rental[:owner_part]),
      add_credit(who: 'insurance', amout: rental[:commission][:insurance_fee]),
      add_credit(who: 'assistance', amout: rental[:commission][:assistance_fee]),
      add_credit(who: 'drivy', amout: rental[:commission][:drivy_fee]),
    ]
  end

  # @param who [String]
  # @param amount [Integer]
  def add_credit(who:, amout:)
    { 'who': who, 'type': 'credit', 'amount': amout }
  end

  # @param who [String]
  # @param amount [Integer]
  def add_debit(who:, amout:)
    { 'who': who, 'type': 'debit', 'amount': amout }
  end
end

