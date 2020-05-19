# frozen_string_literal: true

class Account
  attr_reader :inputted_money, :sales

  AVAILABLE_CHANGE = [10, 50, 100, 500, 1000]

  def initialize(inputted_money: 0, sales: 0)
    @inputted_money = inputted_money
    @sales = sales
  end

  def input_money(money)
    if AVAILABLE_CHANGE.include?(money.value)
      @inputted_money += money.value
      nil
    else
      money.value
    end
  end

  def refund
    inputted_money.tap { @inputted_money = 0 }
  end

  def buy(price)
    @inputted_money -= price.to_i
    @sales += price.to_i
  end
end
