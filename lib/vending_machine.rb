# frozen_string_literal: true

class VendingMachine
  attr_reader :account, :drinks, :changes

  def initialize(account: Account.new, drinks: nil, changes: nil)
    @account = account
    @drinks = drinks
    @changes = changes
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

  def stock_drink(drink)
  end

  def show_stocked_drinks
  end

  def buyable?(drink_name, money)
  end

  def buy(drink_name)
  end

  def show_buyable_drinks
  end

  def add_change(change)
  end

  def show_changes
  end

  def random_buy
  end

  def show_stocked_drinks_expirations
  end
end
