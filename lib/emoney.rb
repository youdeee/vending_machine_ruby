# frozen_string_literal: true

require "money"

class Emoney < Money
  def initialize(value)
    super(value, :emoney)
  end
end
