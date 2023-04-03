defmodule FoodOrderWeb.Admin.ProductLive.IndexTest do
  use FoodOrderWeb.ConnCase
  import Phoenix.LiveViewTest
  import FoodOrder.ProductsFixtures

  describe "index" do
    setup [:create_product]

    test "List products", %{conn: conn, product: product} do
      {:ok, view, _html} = live(conn, ~p"/admin/products")

      assert has_element?(view, "header>div>h1", "List Products")

      product_id_el = "#products-#{product.id}"
      assert has_element?(view, product_id_el)
      assert has_element?(view, product_id_el <> ">td>div>span", Money.to_string(product.price))
      assert has_element?(view, product_id_el <> ">td>div>span", product.name)
      assert has_element?(view, product_id_el <> ">td>div>span", Atom.to_string(product.size))
    end
  end

  defp create_product(_conn) do
    product = product_fixture()
    %{product: product}
  end
end
