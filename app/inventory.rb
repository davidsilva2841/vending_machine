require_relative "./product"

class Inventory
  attr_reader :products

  def initialize(products: nil)
    @products = products.clone || [
      [Product.new(name: "Coco Cola", price: 2), 2],
      [Product.new(name: "Sprite", price: 2.5), 2],
      [Product.new(name: "Fanta", price: 2.25), 3],
      [Product.new(name: "Orange Juice", price: 3), 1],
      [Product.new(name: "Water", price: 3.25), 0],
    ]
  end

  def in_stock?(index:)
    @products[index][1] > 0
  end

  def selection_valid?(selection:)
    if selection.nil?
      puts("Invalid input, please enter a number between 0 and #{@products.length - 1}")
      return false
    end

    if selection < 0 || selection > @products.length - 1
      puts("Invalid selection, please try again")
      return false
    end

    unless in_stock?(index: selection)
      puts("Sorry, you selected an item that's out of stock. Please try again")
      return false
    end

    true
  end

  def get_product(selection:)
    @products[selection][0]
  end

  def dispense_product(selection:)
    @products[selection][1] -= 1
  end
end
