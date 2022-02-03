require_relative "../app/inventory"

describe Inventory do
  describe "#in_stock?" do
    let(:inventory) { Inventory.new(products: [
      [Product.new(name: "product_0", price: 0), 0],
      [Product.new(name: "product_1", price: 1), 1],
    ])}

    it "returns false for products in stock" do
      expect(inventory.in_stock?(index: 0)).to be false
    end

    it "returns true for products in stock" do
      expect(inventory.in_stock?(index: 1)).to be true
    end
  end

  describe "#selection_valid?" do
    let(:inventory) { Inventory.new(products: [
      [Product.new(name: "product_0", price: 0), 0],
      [Product.new(name: "product_1", price: 1), 1],
      [Product.new(name: "product_2", price: 2), 2],
    ])}

    it "returns false for invalid selections" do
      expect(inventory.selection_valid?(selection: nil)).to be false
      expect(inventory.selection_valid?(selection: -1)).to be false
      expect(inventory.selection_valid?(selection: 3)).to be false
      expect(inventory.selection_valid?(selection: 0)).to be false
    end

    it "returns true for valid selections" do
      expect(inventory.selection_valid?(selection: 1)).to be true
      expect(inventory.selection_valid?(selection: 2)).to be true
    end
  end

  describe "#get_product" do
    let(:product_0) { Product.new(name: "product_0", price: 0) }
    let(:product_1) { Product.new(name: "product_1", price: 1) }
    let(:inventory) { Inventory.new(products: [
      [:product_0, 0],
      [:product_1, 1],
    ])}

    it "returns the correct product" do
      product = inventory.get_product(selection: 0)
      expect(product.equal?(:product_0)).to be true
    end
  end

  describe "#dispense_product" do
    let(:inventory) { Inventory.new(products: [
      [Product.new(name: "product_0", price: 0), 0],
      [Product.new(name: "product_1", price: 1), 1],
    ])}

    it "dispenses the correct product and reduces the stock" do
      selection = 1
      expect(inventory.products[selection][1]).to eq(1)
      inventory.dispense_product(selection: 1)
      expect(inventory.products[selection][1]).to eq(0)
    end
  end
end
