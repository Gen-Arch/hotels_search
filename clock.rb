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
  hotels = YAML.load_file('config/hotels.yml')
  hotels.each do |name, info|
    hs = HotelsSearch.new(name, info['url'])
    year  = Date.today.year
    month = Date.today.month + 1
    prices = hs.shaping_cal(month: month)
    hotel = Hotel.where(name: name, plan: info['plan']).where(year: year, month: month).first
    hotel = Hotel.new unless hotel
    hotel.name   = name
    hotel.plan   = info['plan']
    hotel.year   = year
    hotel.month  = month
    hotel.prices = prices
    hotel.save
  end
  puts "Update complete"
end
