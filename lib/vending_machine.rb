# frozen_string_literal: true

require "forwardable"

class VendingMachine
  extend Forwardable

  attr_reader :account, :drink_case

  def_delegators :@drink_case, :drinks_count, :show_drinks
  def_delegators :@account, :inputted_money, :sales, :refund

  def initialize(account: Account.new, drink_case: DrinkCase.new)
    @account = account
    @drink_case = drink_case
  end

  def input_money(money)
    account.input_money(money)
    # changes.add_money(money)
  end

  def buyable?(drink_name)
    drink_case.buyable?(drink_name, account.inputted_money)
  end

  def buy(drink_name)
    price = drink_case.buy(drink_name, account.inputted_money)
    account.buy(price)
  end
end
