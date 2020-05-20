# frozen_string_literal: true

class Drink
  attr_reader :name, :price

  def initialize(name:, price:)
    @name = name.to_s
    @price = price.to_i
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
