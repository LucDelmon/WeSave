# frozen_string_literal: true

require 'json'
require 'date'
require_relative 'lib/models/car'
require_relative 'lib/models/rental'
require_relative 'lib/models/commission'
require_relative 'lib/services/base_service'
require_relative 'lib/services/rental_presenter_service'
require_relative 'lib/services/action_presenter_service'

input_file = File.read('./data/input.json')
action_presenter_service = ActionPresenterService.new(input_file)
actions = action_presenter_service.call

puts JSON.pretty_generate({ "rentals": actions })
