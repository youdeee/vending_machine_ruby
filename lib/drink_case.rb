class DrinkCase
  attr_reader :drinks

  class << self
    def coke_5
      new(Array.new(5, Drink.new(name: "コーラ", price: 120)))
    end
  end

  def initialize(drinks = [])
    @drinks = drinks
  end

  def show_drinks
    drinks_stock.map { |drink, stock| "#{drink.price}円 #{drink.name} #{stock}本" }.join("\n")
  end

  def buyable?(drink_name, money)
    !!buyable_drink(drink_name, money)
  end

  def drinks_count
    drinks.length
  end

  def buy(drink_name, money)
    drink = buyable_drink(drink_name, money)
    return unless drink

    i = @drinks.index { |_1| _1 == drink }
    @drinks.delete_at(i).price
  end

  private

  def buyable_drink(drink_name, money)
    drinks.find { |drink| drink.name == drink_name && drink.price <= money }
  end

  def drinks_stock
    drinks.group_by(&:itself).to_h { |k, v| [k, v.length] }
  end
end
