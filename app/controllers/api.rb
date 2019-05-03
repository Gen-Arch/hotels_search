require 'date'
require 'controllers/base'
require 'sinatra/json'
require 'models/hotel.rb'

class Api < Base
  before do
    cross_origin
    content_type :json
    # protected!
  end

  get '/average_all' do
    year     = params[:year]
    month    = params[:month]
    averages = Array.new

    hotels = Hotel.where(year: year, month: month).to_a
    hotels.each do |hotel|
      prices = hotel.prices.map{|daily_price| daily_price[:price] }
      total = 0
      prices.each{|i| total += i}
      average = total / prices.size
      averages << {name: hotel.name, plan: hotel.plan, average: average}
    end
    json({year: year, month: month, averages: averages})
  end
end
