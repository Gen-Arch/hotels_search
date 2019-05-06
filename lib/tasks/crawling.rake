ENV['RACK_ENV'] ||= 'development'
require 'date'
require 'yaml'
require_relative '../../config/environment.rb'
require_relative '../crawling/hotels_single.rb'
require_relative '../crawling/plan_get.rb'
require 'models/hotel'

namespace :crawling do
  desc 'create crawling url list'
  task :create do
    urls = YAML.load_file(File.join(config, 'scraping_url.yml'))
    hotels = Array.new
    urls.each do |url|
      plan_get = PlanGet.new(url)
      hotels.concat(plan_get.start)
    end
    file = open(File.join(config, 'hotel_plan.yml'), 'w')
    YAML.dump(hotels, file)
  end

  desc 'update database'
  task :update do
    puts "DB Update!!"
      hotels = YAML.load_file(File.join(config, 'hotel_plan.yml'))
      hotels.each do |hotel|
        name = hotel[:name]
        puts "update => #{name}"
        hotel[:plans].each do |plan|
          hs = HotelsSearch.new(name, plan[:url])
          year  = Date.today.year
          month = ( ENV['month'] || Date.today.month + 1).to_i
          begin
            prices = hs.shaping_cal(month: month)
          rescue => err
            puts err
            next
          end
          next if prices.empty?
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
end
