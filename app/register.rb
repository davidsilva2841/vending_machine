class Register
  VALID_COINS = [
    0.25,
    0.50,
    1.00,
    2.00,
    3.00,
    5.00,
  ].sort!.reverse!

  attr_reader :coins

  def initialize(coins: nil)
    @coins = coins.clone || {
      5.0 => 5,
      3.0 => 5,
      2.0 => 5,
      1.0 => 5,
      0.5 => 5,
      0.25 => 5,
    }
  end

  def coin_format(amount:)
    "#{'%.2f' % amount}"
  end

  # @return [Boolean] Returns true if payment processed successfully
  def handle_payment(balance:)
    # Receiving coins from customer
    inserted_coins = {}
    while balance > 0
      puts("Balance: #{coin_format(amount: balance)}")
      input = Float(gets.chomp, exception: false)

      if valid_coin?(coin: input)
        inserted_coins[input] = 0 if inserted_coins[input].nil?

        @coins[input] += 1
        balance -= input
        inserted_coins[input] += 1
      end
    end

    puts("") # Add new line for spacing
    sleep(1)

    # No need to dispense change if balance == 0
    if balance == 0
      true
    else
      # We owe the customer change
      puts("Balance: #{coin_format(amount: balance)}")
      can_make_change, change = calculate_change(balance: balance.abs)

      if can_make_change
        puts("Dispensing change")
        dispense_coins(coins: change)
        true
      else
        puts("Unable to make change for payment, please try again and insert the exact amount of coins")
        puts("Returning your coins...")
        dispense_coins(coins: inserted_coins)
        false
      end
    end
  end

  private

  def valid_coin?(coin:)
    if coin.nil? || coin < 0 || !VALID_COINS.include?(coin)
      puts "Invalid coin, please try again"
      false
    else
      true
    end
  end

  # Calculates if we can make change and what coins to dispense
  # @return [[Boolean, Hash]]
  def calculate_change(balance:)
    change = {}

    VALID_COINS.each do |coin|
      while coin <= balance && @coins[coin] >= 1
        change.merge!({coin => 0}) if change[coin].nil?
        change[coin] += 1
        balance -= coin
      end
    end

    can_make_change = (balance == 0)

    [can_make_change, change]
  end

  def dispense_coins(coins:)
    coins.each do |coin, quantity|
      @coins[coin] -= quantity
      puts("* Dispensing: #{quantity} x #{coin_format(amount: coin)} *")
    end
  end
end
