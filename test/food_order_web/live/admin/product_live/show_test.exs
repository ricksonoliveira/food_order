defmodule FoodOrderWeb.Admin.ProductLive.ShowTest do
  use FoodOrderWeb.ConnCase
  import Phoenix.LiveViewTest
  import FoodOrder.ProductsFixtures

  describe "show" do
    setup [:create_product]

    test "Show product", %{conn: conn, product: product} do
      {:ok, view, _html} = live(conn, ~p"/admin/products/#{product}")

      assert has_element?(view, "div>dt", "Name")
      assert has_element?(view, "div>dd", product.name)
    end
  end

  defp create_product(_conn) do
    product = product_fixture()
    %{product: product}
  end
end
