# frozen_string_literal: true

class DrinkCase
  attr_reader :drinks

  class << self
    def default
      new(Array.new(5) { Drink.new(name: "コーラ", price: 120) })
    end
  end

  def initialize(drinks = [])
    @drinks = sort_drinks(drinks)
  end

  def show_drinks
    drinks_stock.map { |drink, stock| "#{drink.price}円 #{drink.name} #{stock}本" }.join("\n")
  end

  def buyable_drink(drink_name, money)
    drinks.find { |drink| drink.name == drink_name && drink.price <= money }
  end

  def drinks_count
    drinks.length
  end

  def buy(drink_name, money)
    drink = buyable_drink(drink_name, money)
    return unless drink

    i = @drinks.index { |_1| _1 == drink }
    @drinks.delete_at(i)
  end

  def put_drink(drink)
    return unless drink.is_a?(Drink)

    @drinks << drink
    @drinks = sort_drinks(drinks)
  end

  private

  def sort_drinks(drinks)
    drinks.sort_by { |drink| [drink.name, drink.price] }
  end

  def drinks_stock
    drinks.group_by(&:itself).to_h { |k, v| [k, v.length] }
  end
end
