# frozen_string_literal: true

require "forwardable"

class VendingMachine
  extend Forwardable

  def_delegators :@drink_case, :drinks_count, :show_drinks, :put_drink, :show_drinks_expirations
  def_delegators :@change_stock, :show_changes
  def_delegators :@record, :sales

  def initialize(record: Record.new, drink_case: DrinkCase.default, change_stock: ChangeStock.default, inputted_money: Money.new)
    @record = record
    @drink_case = drink_case
    @change_stock = change_stock
    @inputted_money = inputted_money
  end

  def input_money(money)
    if money.is_a?(Coin)
      return money.value unless change_stock.put_change(money)

      reset_inputted_money if inputted_money.type?(:emoney)
      @inputted_money = inputted_money.calc(money, :+)
      nil
    elsif money.type?(:emoney)
      return money.value if inputted_money.type?(:cash)

      @inputted_money = money
      nil
    else
      money.value
    end
  end

  def buyable?(drink_name)
    drink = drink_case.buyable_drink(drink_name, inputted_money.value)
    return false unless drink
    return true if inputted_money.type?(:emoney)

    change_stock.stock_enough?(inputted_money.value - drink.price)
  end

  def buy(drink_name)
    return unless buyable?(drink_name)

    drink = drink_case.buy(drink_name, inputted_money.value)
    @inputted_money = inputted_money.calc(Money.new(drink.price), :-)
    record.add_sales(drink.price)
  end

  def refund
    change_stock.refund(inputted_money.value) if inputted_money.type?(:cash)
    inputted_money.value.tap { reset_inputted_money }
  end

  def random_buyable?
    buyable?(%w(コーラ ダイエットコーラ お茶))
  end

  def random_buy
    buy(%w(コーラ ダイエットコーラ お茶))
  end

  def inputted_value
    inputted_money.value
  end

  private

  attr_reader :record, :drink_case, :change_stock, :inputted_money

  def reset_inputted_money
    @inputted_money = Money.new
  end
end
