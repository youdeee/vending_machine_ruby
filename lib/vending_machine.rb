# frozen_string_literal: true

class VendingMachine
  attr_reader :account

  def initialize(account: Account.new)
    @account = account
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
end
