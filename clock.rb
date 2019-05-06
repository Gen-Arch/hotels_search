ENV['RACK_ENV'] ||= 'development'
require 'date'
require 'yaml'
require 'clockwork'
require 'active_support/duration'
require_relative 'config/environment.rb'
require_relative 'app/models/hotel.rb'
require_relative 'lib/crawling/hotels_single.rb'

include Clockwork

every(1.month, 'crawling') do
  puts "DB Update!!"
  hotels = YAML.load_file(File.join(config, 'hotel_plan.yml'))
  hotels.each do |hotel|
    name = hotel[:name]
    hotel[:plans].each do |plan|
      hs = HotelsSearch.new(name, plan[:url])
      year  = Date.today.year
      month = Date.today.month + 1
      prices = hs.shaping_cal(month: month)
      hotel = Hotel.where(name: name, plan: plan[:name]).where(year: year, month: month).first
      hotel = Hotel.new unless hotel
      hotel.name   = name
      hotel.plan   = plan[:name]
      hotel.year   = year
      hotel.month  = month
      hotel.prices = prices
      hotel.save
    end
  end
  puts "Update complete"
end
