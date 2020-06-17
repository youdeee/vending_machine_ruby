# frozen_string_literal: true

class ChangeStock
  attr_reader :changes

  AVAILABLES = [10, 50, 100, 500, 1000]

  class << self
    def default
      new({
            Coin.new(1000) => 10,
            Coin.new(500) => 10,
            Coin.new(100) => 10,
            Coin.new(50) => 10,
            Coin.new(10) => 10
          })
    end
  end

  def initialize(changes = {})
    changes.delete_if { |_1| !available?(_1) }
    @changes = sort_changes(changes)
  end

  def stock_enough?(value)
    return true if value == 0

    !available_changes(value).empty?
  end

  def put_change(money)
    return unless available?(money)

    @changes[money] = @changes[money].to_i + 1
    @changes = sort_changes(@changes)
  end

  def refund(value)
    available_changes(value).each do |change, count|
      @changes[change] = @changes[change].to_i - count
    end
  end

  def show_changes
    changes.map { |change, count| "#{change.value}円 #{count}個" }.join("\n")
  end

  private

  def available?(coin)
    coin.is_a?(Coin) && AVAILABLES.include?(coin.value)
  end

  def available_changes(change_value)
    changes.each_with_object({}) do |(change, count), acc|
      while change_value >= change.value && count > 0
        acc[change] = acc[change].to_i + 1
        change_value -= change.value
        count -= 1
      end
    end
  end

  def sort_changes(changes)
    changes.sort_by { |money, count| -money.value }.to_h
  end
end
