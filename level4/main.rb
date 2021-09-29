# frozen_string_literal: true

require 'json'
require 'date'
require_relative 'lib/services/rental_service'

input_file = File.read('./data/input.json')
rental_service = RentalService.new(input_file)
computed_rentals = rental_service.call

puts JSON.pretty_generate({ "rentals": computed_rentals })
