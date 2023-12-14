defmodule FoodOrder.CartsTest do
  alias FoodOrder.Carts
  use FoodOrder.DataCase, async: true

  describe "session" do
    test "create cart session" do
      assert Carts.create_session(444) == :ok
    end
  end
end
