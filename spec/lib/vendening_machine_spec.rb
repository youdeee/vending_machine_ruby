# frozen_string_literal: true

describe VendingMachine do
  describe "Step0:" do
    it "有効なお金を入れると合計金額が見れる" do
      vm = VendingMachine.new
      vm.input_money(Coin.new(10))
      vm.input_money(Coin.new(50))
      vm.input_money(Coin.new(10000))

      expect(vm.inputted_money.value).to eq(60)
    end

    it "返金したらお釣りが返り合計金額が0になる" do
      vm = VendingMachine.new
      vm.input_money(Coin.new(10))

      expect(vm.refund).to eq(10)
      expect(vm.inputted_money.value).to eq(0)
    end
  end

  describe "Step1:" do
    it "想定外のお金を入れたらそのままお釣りが出る" do
      vm = VendingMachine.new

      expect(vm.input_money(Coin.new(5))).to eq(5)
      expect(vm.inputted_money.value).to eq(0)
    end
  end

  describe "Step2:" do
    it "格納されているジュースの情報（値段と名前と在庫）を取得できる" do
      vm = VendingMachine.new

      expect(vm.show_drinks).to eq("120円 コーラ 5本")
    end
  end

  describe "Step3:" do
    describe "投入金額、在庫の点で、コーラが購入できるかどうかを取得できる" do
      it "取得できる" do
        vm = VendingMachine.new
        vm.input_money(Coin.new(100))
        vm.input_money(Coin.new(50))

        expect(vm.buyable?("コーラ")).to eq(true)
      end

      it "取得できない（在庫ない）" do
        vm = VendingMachine.new(drink_case: DrinkCase.new)
        vm.input_money(Coin.new(100))
        vm.input_money(Coin.new(50))

        expect(vm.buyable?("コーラ")).to eq(false)
      end

      it "取得できない（お金足りない）" do
        vm = VendingMachine.new
        vm.input_money(Coin.new(100))

        expect(vm.buyable?("コーラ")).to eq(false)
      end
    end

    it "ジュース値段以上の投入金額が投入されている条件下で購入操作を行うと、ジュースの在庫を減らし、売り上げ金額を増やす" do
      vm = VendingMachine.new
      vm.input_money(Coin.new(100))
      vm.input_money(Coin.new(50))

      expect { vm.buy("コーラ") }.to change { vm.drinks_count }.by(-1)
      expect(vm.inputted_money.value).to eq(30)
      expect(vm.sales).to eq(120)
    end

    it "投入金額が足りない場合もしくは在庫がない場合、購入操作を行っても何もしない" do
      vm = VendingMachine.new
      vm.input_money(Coin.new(100))
      vm.input_money(Coin.new(10))

      expect { vm.buy("コーラ") }.to change { vm.drinks_count }.by(0)
      expect(vm.inputted_money.value).to eq(110)
      expect(vm.sales).to eq(0)
    end

    it "払い戻し操作では現在の投入金額からジュース購入金額を引いた釣り銭を出力する" do
      vm = VendingMachine.new
      vm.input_money(Coin.new(100))
      vm.input_money(Coin.new(50))
      vm.buy("コーラ")

      expect(vm.refund).to eq(30)
    end
  end

  describe "Step4:" do
    it "ジュースを3種類管理できるようにする" do
      vm = VendingMachine.new
      vm.put_drink(Drink.new(name: "レッドブル", price: 200))
      vm.put_drink(Drink.new(name: "水", price: 100))
      vm.put_drink(Drink.new(name: "水", price: 100))
      vm.put_drink(Drink.new(name: "水", price: 100))
      vm.put_drink(Drink.new(name: "レッドブル", price: 200))
      vm.put_drink(Drink.new(name: "水", price: 100))
      vm.put_drink(Drink.new(name: "レッドブル", price: 200))
      vm.put_drink(Drink.new(name: "水", price: 100))
      vm.put_drink(Drink.new(name: "レッドブル", price: 200))
      vm.put_drink(Drink.new(name: "レッドブル", price: 200))

      expect(vm.show_drinks).to eq("120円 コーラ 5本\n200円 レッドブル 5本\n100円 水 5本")
    end
  end

  describe "Step6:" do
    it "お釣りがないと買えない" do
      vm = VendingMachine.new(change_stock: ChangeStock.new)
      vm.input_money(Coin.new(100))
      vm.input_money(Coin.new(50))

      expect { vm.buy("コーラ") }.to change { vm.drinks_count }.by(0)
      expect(vm.inputted_money.value).to eq(150)
      expect(vm.sales).to eq(0)
    end

    it "お釣りがなくてもぴったしなら買える" do
      vm = VendingMachine.new(change_stock: ChangeStock.new)
      vm.input_money(Coin.new(100))
      vm.input_money(Coin.new(10))
      vm.input_money(Coin.new(10))
      vm.input_money(Coin.new(10))

      expect { vm.buy("コーラ") }.to change { vm.drinks_count }.by(-1)
      expect(vm.inputted_money.value).to eq(10)
      expect(vm.sales).to eq(120)
      expect(vm.refund).to eq(10)
    end

    it "釣り銭用ストックを取得できる" do
      change_stock = ChangeStock.new({
        Coin.new(100) => 9,
        Coin.new(50) => 18,
        Coin.new(1000) => 9,
        Coin.new(10) => 1
      })
      vm = VendingMachine.new(change_stock: change_stock)
      vm.input_money(Coin.new(1000))

      expect(vm.show_changes).to eq("1000円 10個\n100円 9個\n50円 18個\n10円 1個")
    end
  end

  describe "Step7:" do
    it "ランダム購入 お金が足りないと買えない" do
      vm = VendingMachine.new
      vm.put_drink(Drink.new(name: "ダイエットコーラ", price: 120))
      vm.put_drink(Drink.new(name: "ダイエットコーラ", price: 120))
      vm.put_drink(Drink.new(name: "ダイエットコーラ", price: 120))
      vm.put_drink(Drink.new(name: "ダイエットコーラ", price: 120))
      vm.put_drink(Drink.new(name: "ダイエットコーラ", price: 120))
      vm.put_drink(Drink.new(name: "お茶", price: 120))
      vm.put_drink(Drink.new(name: "お茶", price: 120))
      vm.put_drink(Drink.new(name: "お茶", price: 120))
      vm.put_drink(Drink.new(name: "お茶", price: 120))
      vm.put_drink(Drink.new(name: "お茶", price: 120))
      vm.input_money(Coin.new(100))

      expect { vm.random_buy }.to change { vm.drinks_count }.by(0)
      expect(vm.inputted_money.value).to eq(100)
      expect(vm.sales).to eq(0)
    end

    it "ランダム購入" do
      vm = VendingMachine.new
      vm.put_drink(Drink.new(name: "ダイエットコーラ", price: 120))
      vm.put_drink(Drink.new(name: "ダイエットコーラ", price: 120))
      vm.put_drink(Drink.new(name: "ダイエットコーラ", price: 120))
      vm.put_drink(Drink.new(name: "ダイエットコーラ", price: 120))
      vm.put_drink(Drink.new(name: "ダイエットコーラ", price: 120))
      vm.put_drink(Drink.new(name: "お茶", price: 120))
      vm.put_drink(Drink.new(name: "お茶", price: 120))
      vm.put_drink(Drink.new(name: "お茶", price: 120))
      vm.put_drink(Drink.new(name: "お茶", price: 120))
      vm.put_drink(Drink.new(name: "お茶", price: 120))
      vm.input_money(Coin.new(100))
      vm.input_money(Coin.new(50))

      expect { vm.random_buy }.to change { vm.drinks_count }.by(-1)
      expect(vm.inputted_money.value).to eq(30)
      expect(vm.sales).to eq(120)
    end
  end

  describe "Extra2(賞味期限管理):" do
    it "賞味期限が切れてたらジュースを買えない" do
      drink_case = DrinkCase.new([
                                   Drink.new(name: "コーラ", price: 120, expiration: Date.today.prev_day)
                                 ])
      vm = VendingMachine.new(drink_case: drink_case)
      vm.input_money(Coin.new(500))

      expect { vm.buy("コーラ") }.to change { vm.drinks_count }.by(0)
      expect(vm.sales).to eq(0)
    end

    it "賞味期限が切れてたらジュースを買えない" do
      drink_case = DrinkCase.new([
                                   Drink.new(name: "コーラ", price: 120, expiration: Date.today.prev_day),
                                   Drink.new(name: "コーラ", price: 120, expiration: Date.today)
                                 ])
      vm = VendingMachine.new(drink_case: drink_case)
      vm.input_money(Coin.new(500))

      expect { vm.buy("コーラ") }.to change { vm.drinks_count }.by(-1)
      expect(vm.sales).to eq(120)
    end

    it "賞味期限を表示" do
      today = Date.new(2020, 5, 22)
      drink_case = DrinkCase.new([
                                   Drink.new(name: "コーラ", price: 120, expiration: today),
                                   Drink.new(name: "コーラ", price: 120, expiration: today.prev_day),
                                   Drink.new(name: "お茶", price: 100, expiration: today.next_year)
                                 ])
      vm = VendingMachine.new(drink_case: drink_case)

      expect(vm.show_drinks_expirations).to eq("100円 お茶 賞味期限 2021年05月22日\n120円 コーラ 賞味期限 2020年05月21日\n120円 コーラ 賞味期限 2020年05月22日")
    end
  end

  describe "Original1(電子マネー対応)" do
    it "電子マネーでコーラを購入できる" do
      vm = VendingMachine.new
      vm.input_money(Emoney.new(1234))
      changes = vm.show_changes

      expect { vm.buy("コーラ") }.to change { vm.drinks_count }.by(-1)
      expect(vm.inputted_money.value).to eq(1114)
      expect(vm.sales).to eq(120)
      expect(vm.refund).to eq(1114)
      expect(vm.show_changes).to eq(changes)
    end

    it "おつりがなくても電子マネーでコーラを購入できる" do
      vm = VendingMachine.new(change_stock: ChangeStock.new)
      vm.input_money(Emoney.new(1234))

      expect { vm.buy("コーラ") }.to change { vm.drinks_count }.by(-1)
      expect(vm.inputted_money.value).to eq(1114)
      expect(vm.sales).to eq(120)
      expect(vm.refund).to eq(1114)
    end

    it "電子マネーを入れた後に現金を入れると、電子マネーはキャンセルされる" do
      vm = VendingMachine.new
      vm.input_money(Emoney.new(1234))
      vm.input_money(Coin.new(500))

      expect(vm.inputted_money.value).to eq(500)
    end

    it "現金を入れた後に電子マネーを入れると、電子マネーは無視される" do
      vm = VendingMachine.new
      vm.input_money(Coin.new(500))
      vm.input_money(Emoney.new(1234))

      expect(vm.inputted_money.value).to eq(500)
    end

    it "電子マネーを入れた後に電子マネーを入れると、最初の電子マネーはキャンセルされる" do
      vm = VendingMachine.new
      vm.input_money(Emoney.new(1234))
      vm.input_money(Emoney.new(234))

      expect(vm.inputted_money.value).to eq(234)
    end
  end
end
