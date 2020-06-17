# frozen_string_literal: true

class Record
  attr_reader :sales

  def initialize(sales: 0)
    @sales = sales
  end

  def add_sales(value)
    @sales += value
  end
end
