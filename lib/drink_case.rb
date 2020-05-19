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

  private

  def drinks_stock
    drinks.group_by(&:itself).to_h { |k, v| [k, v.length] }
  end
end
