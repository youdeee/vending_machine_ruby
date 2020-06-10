# frozen_string_literal: true

require_relative "./money"

class Coin < Money
  AVAILABLE_VALUE = [1, 5, 10, 50, 100, 500, 1000, 2000, 5000, 10000]

  def initialize(value)
    raise unless AVAILABLE_VALUE.include?(value)

    super(value, :cash)
  end
end
