require 'mongoid'
Mongoid.load!(File.join(config, 'mongoid.yml'))

class Hotel
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,   type: String
  field :plan,   type: String
  field :year,   type: Integer
  field :month,  type: Integer
  field :prices, type: Array
end
