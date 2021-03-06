# frozen_string_literal: true

class Money
  attr_reader :value, :type

  AVAILABLE_VALUE = [1, 5, 10, 50, 100, 500, 1000, 2000, 5000, 10000]

  def initialize(value = 0, type = nil)
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

  def calc(money, operator)
    return self if type != money.type && type != nil && money.type != nil

    self.class.new(value.public_send(operator, money.value), [type, money.type].compact[0])
  end

  def type?(type)
    self.type == type
  end
end
