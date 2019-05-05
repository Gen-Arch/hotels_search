require 'selenium-webdriver'

class PlanGet
  def initialize(url)
    @url = url
    @wait = wait = Selenium::WebDriver::Wait.new(:timeout => 10)
    @driver = get_driver
    @driver.get(@url)
  end

  def start
    hotels = get_plans
    hotels.map do |hotel|
      hotel[:plans].map!(&method(:link_conversion))
      hotel
    end
  end

  def get_plans
    hotel_plans = Array.new
    hotels = @driver.find_elements(:class, 'search-result-cassette')
    hotels.each do |hotel|
      name = hotel.find_element(:class, 'hotel-name').text
      plan_list = hotel.find_element(:class, 'hotel-detail-plan')
      plans = plan_list.find_elements(:tag_name, 'tr')
      plans.shift
      plans = plans.map(&method(:plan_link)).compact
      hotel_plans << {name: name, plans: plans}
    end
    hotel_plans
  end

  private
  def link_conversion(plan)
    return unless plan
    @driver.get(@url)
    @driver.execute_script(plan[:url])
    url = @driver.current_url
    plan[:url] = url
    plan
  end

  def plan_link(plan)
    begin
      link = plan.find_element(:tag_name, 'td').find_element(:tag_name, 'a')
    rescue Selenium::WebDriver::Error::NoSuchElementError
      return
    end
    name = link.text
    url  = link.attribute('href')
    {name: name, url: url}
  end

  def get_driver
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    Selenium::WebDriver.for :chrome, options: options
  end
end

if __FILE__ == $0
  require_relative '../../config/environment.rb'
  require 'yaml'
  urls = YAML.load_file(File.join(config, 'scraping_url.yml'))
  hotels = Array.new
  urls.each do |url|
    plan_get = PlanGet.new(url)
    hotels.concat(plan_get.start)
  end
  YAML.dump(hotels, open('hotel_plan.yml', 'w'))
end
