require_relative "./inventory"
require_relative "./register"

class VendingMachine
  attr_reader :inventory, :register

  def initialize
    @inventory = Inventory.new
    @register = Register.new
    run
  end

  private

  def run
    begin
      puts("\n---------------------------------------------")
      greet
      selection, product = select_product
      paid = process_payment(product: product)
      sleep(1)

      if paid
        puts("\n* Dispensing: #{product.name} *")
        @inventory.dispense_product(selection: selection)
        puts("Thanks for shopping with us!\n\n")
        sleep(1)
      end

      run
    rescue Interrupt
      puts("Goodbye...")
      exit(0)
    rescue => error
      puts("Uh oh, something broke...")
      raise error
    end
  end

  # Greets customer & displays options
  def greet
    puts("Welcome to David's Vending Machine!")
    puts("(Press CTRL + c at anytime to exit...)")
    sleep(1)
    puts("\nPlease select your order:")

    # Display options
    @inventory.products.each_with_index do |product, index|
      in_stock = @inventory.in_stock?(index: index)
      price = @register.coin_format(amount: product[0].price)
      puts("#{index}) #{product[0].name} - #{price} #{in_stock ? "" : " - [OUT OF STOCK]"}" )
    end

    puts("") # Add new line for spacing
  end

  # Prompts user to select product
  # @return [[Integer], [Product]]
  def select_product
    selection = Integer(gets.chomp, exception: false)

    unless @inventory.selection_valid?(selection: selection)
      return select_product
    end

    product = @inventory.get_product(selection: selection)
    price = @register.coin_format(amount: product.price)
    puts("Selected product: #{product.name} - Cost: #{price}\n\n")
    sleep(1)

    [selection, product]
  end

  # @return [Boolean] Returns true if payment processed successfully
  def process_payment(product:)
    puts("Please insert coins:")

    @register.handle_payment(balance: product.price)
  end
end
