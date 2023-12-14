defmodule FoodOrder.Carts.Core.HandleCartsTest do
  use FoodOrder.DataCase, async: true

  alias FoodOrder.Carts.Data.Cart

  import FoodOrder.Carts.Core.HandleCarts
  import FoodOrder.ProductsFixtures

  @cart_init %Cart{
    id: 444_444,
    items: [],
    total_price: %Money{amount: 0, currency: :USD},
    total_qty: 0
  }

  describe "cart" do
    test "create a new cart" do
      assert @cart_init == create(444_444)
    end
  end

  describe "add" do
    test "add/2 add new item to the cart" do
      product = product_fixture()

      cart = add(@cart_init, product)

      assert 1 == cart.total_qty
      assert [%{item: product, qty: 1}] == cart.items
      assert product.price == cart.total_price
    end

    test "add/2 adds same item twice" do
      product = product_fixture()

      cart = add(@cart_init, product) |> add(product)

      assert 2 == cart.total_qty
      assert [%{item: product, qty: 2}] == cart.items
      assert Money.add(product.price, product.price) == cart.total_price
    end
  end

  describe "remove" do
    test "remove/2 removes an item from cart" do
      product = product_fixture()
      product_2 = product_fixture()

      cart =
        @cart_init
        |> add(product)
        |> add(product)
        |> add(product_2)

      assert 3 == cart.total_qty

      assert product.price |> Money.add(product.price) |> Money.add(product_2.price) ==
               cart.total_price

      assert [%{item: product, qty: 2}, %{item: product_2, qty: 1}] == cart.items

      cart = remove(cart, product.id)

      assert 1 == cart.total_qty
      assert product_2.price == cart.total_price
      assert [%{item: product_2, qty: 1}] == cart.items
    end
  end

  describe "increase" do
    test "increment/2 the same element" do
      product = product_fixture()

      cart =
        @cart_init
        |> add(product)
        |> add(product)
        |> increment(product.id)

      assert 3 == cart.total_qty

      assert product.price |> Money.add(product.price) |> Money.add(product.price) ==
               cart.total_price
    end
  end

  describe "decrease" do
    test "decrease/2 the same element" do
      product = product_fixture()

      cart =
        @cart_init
        |> add(product)
        |> add(product)
        |> decrement(product.id)

      assert 1 == cart.total_qty

      assert product.price |> Money.add(product.price) |> Money.subtract(product.price) ==
               cart.total_price
    end

    test "decrease/2 item until it's removed from cart" do
      product = product_fixture()

      cart =
        @cart_init
        |> add(product)
        |> add(product)
        |> decrement(product.id)
        |> decrement(product.id)

      assert 0 == cart.total_qty
      assert [] == cart.items
      assert Money.new(0) == cart.total_price
    end
  end
end
