# frozen_string_literal: true

class ChangeStock
  attr_reader :changes

  class << self
    def default
      new({
            Money.new(1000) => 10,
            Money.new(500) => 10,
            Money.new(100) => 10,
            Money.new(50) => 10,
            Money.new(10) => 10
          })
    end
  end

  def initialize(changes = {})
    @changes = sort_changes(changes)
  end

  def buyable?(money_value)
    return true if money_value.to_i == 0

    !available_changes(money_value).empty?
  end

  def put_change(money)
    @changes[money] = @changes[money].to_i + 1
    @changes = sort_changes(@changes)
  end

  def refund(money_value)
    available_changes(money_value).each do |change, count|
      @changes[change] = @changes[change].to_i - count
    end
  end

  def show_changes
    changes.map { |change, count| "#{change.value}円 #{count}個" }.join("\n")
  end

  private

  def available_changes(change_value)
    changes.each_with_object({}) do |(change, count), acc|
      i = count
      while change_value >= change.value && i > 0
        acc[change] = acc[change].to_i + 1
        change_value -= change.value
        i -= 1
      end
    end
  end

  def sort_changes(changes)
    changes.sort_by { |money, count| -money.value }.to_h
  end
end
