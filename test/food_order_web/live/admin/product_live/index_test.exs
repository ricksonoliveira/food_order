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

    test "add new product", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/admin/products")

      assert view |> element("header>div>a", "New Product") |> render_click()

      assert_patch(view, ~p"/admin/products/new")

      assert view |> has_element?("#new-product-modal")

      # open_browser(view)
      assert view
              |> form("#product-form", product: %{})
              |> render_change() =~ "be blank"
    end
  end

  defp create_product(_conn) do
    product = product_fixture()
    %{product: product}
  end
end
