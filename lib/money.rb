# frozen_string_literal: true

class Money
  attr_reader :value, :type
  private_class_method :new

  AVAILABLE_VALUE = [1, 5, 10, 50, 100, 500, 1000, 2000, 5000, 10000]

  class << self
    def cash(value)
      new(AVAILABLE_VALUE.include?(value) ? value : 0, :cash)
    end

    def emoney(value)
      new(value, :emoney)
    end
  end

  def initialize(value, type = :cash)
    @value = value
    @type = type
  end

  def eql?(other)
    value == other.value &&
      type == other.type
  end
  alias :== eql?

  def hash
    [value, type].hash
  end

  def cash?
    type == :cash
  end
end
