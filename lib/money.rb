# frozen_string_literal: true

class Money
  attr_reader :value

  AVAILABLE_VALUE = [1, 5, 10, 50, 100, 500, 1000, 2000, 5000, 10000]

  def initialize(value)
    @value = value if AVAILABLE_VALUE.include?(value)
  end

  def eql?(other)
   value == other.value
  end
  alias :== eql?

  def hash
    [value].hash
  end
end
