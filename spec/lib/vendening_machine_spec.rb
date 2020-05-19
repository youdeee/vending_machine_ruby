# frozen_string_literal: true

describe "自販機" do
  context "Step0:" do
    it "有効なお金を入れると合計金額が見れる" do
      vm = VendingMachine.new
      vm.input_money(Money.new(10))
      vm.input_money(Money.new(50))
      vm.input_money(Money.new(10000))

      expect(vm.show_inputted_money).to eq(60)
    end

    it "返金したらお釣りが返り合計金額が0になる" do
      vm = VendingMachine.new
      vm.input_money(Money.new(10))

      expect(vm.refund).to eq(10)
      expect(vm.show_inputted_money).to eq(0)
    end
  end

  context "Step1:" do
    it "想定外のお金を入れたらそのままお釣りが出る" do
      vm = VendingMachine.new
      expect(vm.input_money(Money.new(5))).to eq(5)
      expect(vm.show_inputted_money).to eq(0)
    end
  end
end
