# frozen_string_literal: true

require_relative "./money"

class Emoney < Money
  def initialize(value)
    super(value, :emoney)
  end
end
