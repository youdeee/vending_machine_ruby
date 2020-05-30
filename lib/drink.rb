# frozen_string_literal: true

require "date"

class Drink
  attr_reader :name, :price, :expiration

  def initialize(name:, price:, expiration: Date.today.next_year)
    @name = name.to_s
    @price = price.to_i
    @expiration = expiration.to_date
  end

  def eql?(other)
    name == other.name &&
      price == other.price
  end
  alias :== eql?

  def hash
    [name, price].hash
  end
end
