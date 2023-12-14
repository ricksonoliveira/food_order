defmodule FoodOrder.CartsTest do
  use FoodOrder.DataCase, async: true
  import FoodOrder.Carts
  import FoodOrder.ProductsFixtures

  describe "session" do
    test "create/1 creates cart session" do
      assert create(444) == :ok
    end

    test "create/1 creates cart session twice" do
      assert create(444) == :ok
      assert create(444) == :ok
    end
  end

  describe "add and decrease" do
    test "add/1 adds product to cart" do
      cart_id = Ecto.UUID.generate()
      create(cart_id)

      product = product_fixture()
      assert :ok == add(cart_id, product)
      assert 1 == get(cart_id).total_qty
    end

    test "add/1 add same product" do
      cart_id = Ecto.UUID.generate()
      create(cart_id)

      product = product_fixture()
      assert :ok == add(cart_id, product)
      assert 2 == increment(cart_id, product.id).total_qty
    end

    test "add/1 increment same product" do
      cart_id = Ecto.UUID.generate()
      create(cart_id)

      product = product_fixture()
      assert :ok == add(cart_id, product)
      assert 2 == increment(cart_id, product.id).total_qty
      assert 3 == increment(cart_id, product.id).total_qty
    end

    test "decrement/1 decrement added product" do
      cart_id = Ecto.UUID.generate()
      create(cart_id)

      product = product_fixture()
      assert :ok == add(cart_id, product)
      assert 0 == decrement(cart_id, product.id).total_qty
    end
  end

  describe "remove" do
    test "remove/1 removes from cart" do
      cart_id = Ecto.UUID.generate()
      create(cart_id)

      product = product_fixture()
      product_2 = product_fixture()

      assert :ok == add(cart_id, product)
      assert :ok == add(cart_id, product_2)

      assert 2 == get(cart_id).total_qty
      assert 1 == remove(cart_id, product.id).total_qty
    end
  end
end
