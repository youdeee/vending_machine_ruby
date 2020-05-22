# frozen_string_literal: true

require "forwardable"

class VendingMachine
  extend Forwardable

  attr_reader :account, :drink_case, :change_stock

  def_delegators :@drink_case, :drinks_count, :show_drinks, :put_drink
  def_delegators :@change_stock, :show_changes
  def_delegators :@account, :inputted_money, :sales

  def initialize(account: Account.new, drink_case: DrinkCase.default, change_stock: ChangeStock.default)
    @account = account
    @drink_case = drink_case
    @change_stock = change_stock
  end

  def input_money(money)
    change_stock.put_change(money)
    account.input_money(money)
  end

  def buyable?(drink_name)
    drink = drink_case.buyable_drink(drink_name, account.inputted_money)
    return false unless drink

    change_stock.buyable?(account.inputted_money - drink.price)
  end

  def buy(drink_name)
    return unless buyable?(drink_name)

    drink = drink_case.buy(drink_name, account.inputted_money)
    account.buy(drink.price)
  end

  def refund
    change_stock.refund(account.inputted_money)
    account.refund
  end
end
