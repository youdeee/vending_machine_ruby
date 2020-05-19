# frozen_string_literal: true

class VendingMachine
  attr_reader :account, :drink_case

  def initialize(account: Account.new, drink_case: DrinkCase.new)
    @account = account
    @drink_case = drink_case
  end

  def input_money(money)
    account.input_money(money)
    # changes.add_money(money)
  end

  def show_inputted_money
    account.inputted_money
  end

  def refund
    account.refund
  end

  def show_drinks
    drink_case.show_drinks
  end
end
