describe Money  do
  describe "#calc" do
    it "cash + cash" do
      expect(Money.new(60, :cash).calc(Money.new(40, :cash), :+)).to eq(Money.new(100, :cash))
    end

    it "nil + nil" do
      expect(Money.new(60).calc(Money.new(40), :+)).to eq(Money.new(100))
    end

    it "cash + nil" do
      expect(Money.new(60, :cash).calc(Money.new(40), :+)).to eq(Money.new(100, :cash))
    end

    it "nil + emoney" do
      expect(Money.new(60).calc(Money.new(40, :emoney), :+)).to eq(Money.new(100, :emoney))
    end

    it "cash + emoney(違うtypeのときはレシーバーを優先して計算しない)" do
      expect(Money.new(60, :cash).calc(Money.new(40, :emoney), :+)).to eq(Money.new(60, :cash))
    end
  end
end
