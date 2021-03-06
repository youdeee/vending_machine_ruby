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
    if drink_name.is_a?(Array) # ランダム購入
      drinks.shuffle.find { |drink| drink_name.include?(drink.name) && drink.price <= money && drink.expiration >= Date.today }
    else
      drinks.find { |drink| drink.name == drink_name && drink.price <= money && drink.expiration >= Date.today }
    end
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

  def show_drinks_expirations
    drinks.map { |drink| "#{drink.price}円 #{drink.name} 賞味期限 #{drink.expiration.strftime('%Y年%m月%d日')}" }.join("\n")
  end

  private

  def sort_drinks(drinks)
    drinks.sort_by { |drink| [drink.name, drink.price, drink.expiration] }
  end

  def drinks_stock
    drinks.group_by(&:itself).to_h { |k, v| [k, v.length] }
  end
end
