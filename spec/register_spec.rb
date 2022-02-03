require_relative "../app/register"

describe Register do
  describe "#coin_format" do
    let(:register) { Register.new }

    it "formats numbers correctly" do
      expect(register.coin_format(amount: 0.01)).to eq("0.01")
      expect(register.coin_format(amount: 0.1)).to eq("0.10")
      expect(register.coin_format(amount: 5)).to eq("5.00")
    end
  end

  describe "#valid_coin?" do
    let(:register) { Register.new }

    it "returns true for valid coins" do
      expect(register.send(:valid_coin?, coin: 0.25)).to be true
      expect(register.send(:valid_coin?, coin: 0.50)).to be true
      expect(register.send(:valid_coin?, coin: 2)).to be true
      expect(register.send(:valid_coin?, coin: 5.00)).to be true
    end

    it "returns false for invalid coins" do
      expect(register.send(:valid_coin?, coin: 0.11)).to be false
      expect(register.send(:valid_coin?, coin: -1)).to be false
      expect(register.send(:valid_coin?, coin: nil)).to be false
    end
  end

  describe "#calculate_change" do
    let(:register) { Register.new(coins: {
      5.0 => 5,
      3.0 => 5,
      2.0 => 5,
      1.0 => 5,
      0.5 => 5,
      0.25 => 0,
    })}

    it "returns the correct amount of change" do
      can_make_change, change = register.send(:calculate_change, balance: 1.50)
      expect(can_make_change).to be true
      expect(change).to eq({ 1.0 => 1, 0.5 => 1 })
    end

    it "returns false when cannot dispense change" do
      can_make_change, _ = register.send(:calculate_change, balance: 1.25)
      expect(can_make_change).to be false
    end
  end

  describe "#dispense_coins" do
    let(:coins_t0) {
      {
        5.0 => 5,
        3.0 => 5,
        2.0 => 0,
        1.0 => 1,
        0.5 => 3,
        0.25 => 5,
      }
    }
    let(:register) { Register.new(coins: coins_t0)}

    it "dispenses the correct amount of coins" do
      expect(register.coins).to eq(coins_t0)
      register.send(:dispense_coins, coins: {
        2.0 => 0,
        1.0 => 1,
        0.5 => 2,
        0.25 => 3,
      })

      expect(register.coins).to eql({
        5.0 => 5,
        3.0 => 5,
        2.0 => 0,
        1.0 => 0,
        0.5 => 1,
        0.25 => 2,
      })
    end
  end
end
