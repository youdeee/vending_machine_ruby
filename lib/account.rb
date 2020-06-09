# frozen_string_literal: true

class Account
  attr_reader :inputted_money, :sales, :inputted_money_type

  AVAILABLE_CHANGE = [10, 50, 100, 500, 1000]

  def initialize(inputted_money: 0, sales: 0, inputted_money_type: nil)
    @inputted_money = inputted_money
    @sales = sales
    @inputted_money_type = inputted_money_type
  end

  def input_money(money)
    return money.value if @inputted_money_type == :cash && !money.cash? # cash→emoneyだったらemoneyは無視

    refund if @inputted_money_type == :emoney # emoney→だったら前のemoneyはキャンセル
    @inputted_money_type = money.type

    return money.value if money.cash? && !AVAILABLE_CHANGE.include?(money.value)

    @inputted_money += money.value
    nil
  end

  def refund
    inputted_money_type = nil
    inputted_money.tap { @inputted_money = 0 }
  end

  def buy(price)
    @inputted_money -= price.to_i
    @sales += price.to_i
  end
end
