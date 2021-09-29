# frozen_string_literal: true

require 'json'
require 'date'
require_relative 'lib/services/rental_service'
require_relative 'lib/services/action_presenter_service'

input_file = File.read('./data/input.json')
rental_service = RentalService.new(input_file)
computed_rentals = rental_service.call
action_presenter_service = ActionPresenterService.new(computed_rentals)
actions = action_presenter_service.call

puts JSON.pretty_generate({ "rentals": actions })
