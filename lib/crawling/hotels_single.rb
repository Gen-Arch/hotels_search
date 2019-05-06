require 'selenium-webdriver'
require 'uri'
require 'date'
require 'addressable/uri'

class HotelsSearch
  def initialize(name, url)
    @name = name
    @url  = url
  end

  def shaping_cal(year: nil, month: nil)
    prices = Array.new
    year  ||= Date.today.year
    month ||= Date.today.month
    url = create_url(year, month)
    cal = get_cal(url)
    cal.each do |day, price, *other|
      price = price_conversion(price)
      next if price.to_i == 0
      daily_price = { date: Date.new(year.to_i, month.to_i, day.to_i), price: price.to_i}
      prices << daily_price
    end
    prices
  end

  private
  def price_conversion(price)
    case price
    when /^￥/
      price.gsub(/￥|,/, '')
    else price
    end
  end

  def create_url(year, month)
    parsed_url = Addressable::URI.parse(@url)
    query = parsed_url.query_values
    query['calMonth'] = month.to_s
    query['calYear']  = year.to_s
    parsed_url.query_values = query
    parsed_url.to_s
  end

  def get_cal(url)
    cal_info = Array.new
    begin
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument('--headless')
      driver = Selenium::WebDriver.for :chrome, options: options
      driver.get(url)
      cal = driver.find_element(:class, 'details01-charge01').find_elements(:class, 'jlnpc-resv-cal__body-row')
      cal.each do |c|
        td = c.find_elements(:tag_name, 'td')
        td = td.map{|e| e.text.split("\n").map(&:strip) }
        cal_info.concat(td)
        cal_info.delete_if(&:empty?)
      end
      cal_info
    rescue => err
      return nil
    ensure
      driver.quit
    end
  end
end

if __FILE__ == $0
  require 'yaml'
  require_relative '../../config/environment.rb'
  require_relative 'plan_get'
  require 'date'

  hotels = YAML.load_file('test.yml')
  hotels.each do |hotel|
    hotel[:plans].each do |plan|
      hs = HotelsSearch.new(hotel[:name], plan[:url])
      year  = Date.today.year
      month = Date.today.month + 1
      prices = hs.shaping_cal(month: month)
      p prices
      exit
    end
  end
end
