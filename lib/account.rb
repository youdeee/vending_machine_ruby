# frozen_string_literal: true

class Account
  attr_reader :inputted_money, :sales


  def initialize(inputted_money: Money.new, sales: 0)
    @inputted_money = inputted_money
    @sales = sales
  end

  def input_money(money)
    return money.value if @inputted_money.type?(:cash) && money.type?(:emoney)

    refund if @inputted_money.type?(:emoney)
    @inputted_money = @inputted_money.calc(money, :+)
    nil
  end

  def refund
    inputted_money.value.tap { @inputted_money = Money.new }
  end

  def buy(price)
    @inputted_money = @inputted_money.calc_value(price.to_i, :-)
    @sales += price.to_i
  end
end
