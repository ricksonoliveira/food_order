defmodule FoodOrderWeb.Admin.ProductLive.SearchByProductTest do
  use FoodOrderWeb.ConnCase, async: true
  import FoodOrder.ProductsFixtures
  import Phoenix.LiveViewTest

  describe "search_by_product/1" do
    setup [:register_and_log_in_admin]

    test "searches a product by its name", %{conn: conn} do
      {product_1, product_2} = create_products()

      # Visit the admin products page
      {:ok, lv, _html} = live(conn, ~p"/admin/products")

      # Get product elements
      product_1_id_el = "#products-#{product_1.id}"
      product_2_id_el = "#products-#{product_2.id}"

      # Assert that both products are present
      assert has_element?(lv, product_1_id_el)
      assert has_element?(lv, product_2_id_el)

      # Filter by name of the product_2
      search_form(lv, product_2.name)

      # Assert that only product_2 is present after filtering
      refute has_element?(lv, product_1_id_el)
      assert has_element?(lv, product_2_id_el)
    end

    test "searches an invalid product", %{conn: conn} do
      {product_1, product_2} = create_products()

      # Visit the admin products page
      {:ok, lv, _html} = live(conn, ~p"/admin/products")

      # Get product elements
      product_1_id_el = "#products-#{product_1.id}"
      product_2_id_el = "#products-#{product_2.id}"

      # Assert that both products are present
      assert has_element?(lv, product_1_id_el)
      assert has_element?(lv, product_2_id_el)

      # Filter by invalid product
      search_form(lv, "invalid product")

      # Assert that only product_2 is present after filtering
      refute has_element?(lv, product_1_id_el)
      refute has_element?(lv, product_2_id_el)
    end

    test "searches for blank product name", %{conn: conn} do
      {product_1, product_2} = create_products()

      # Visit the admin products page
      {:ok, lv, _html} = live(conn, ~p"/admin/products")

      # Get product elements
      product_1_id_el = "#products-#{product_1.id}"
      product_2_id_el = "#products-#{product_2.id}"

      # Assert that both products are present
      assert has_element?(lv, product_1_id_el)
      assert has_element?(lv, product_2_id_el)

      # Filter by blank
      search_form(lv, "")

      # Assert that only product_2 is present after filtering
      assert has_element?(lv, product_1_id_el)
      assert has_element?(lv, product_2_id_el)
    end

    test "suggest product name", %{conn: conn} do
      {product_1, _product_2} = create_products()

      # Visit the admin products page
      {:ok, lv, _html} = live(conn, ~p"/admin/products")

      # Assert that the datalist is present
      assert lv |> element("#names") |> render =~ "<datalist id=\"names\">"

      # Filter by name of the product_1
      lv
      |> form("[phx-submit=filter_by_product]", %{name: product_1.name})
      |> render_change()

      # Assert that the product_1 name is present in the datalist
      assert lv |> element("#names") |> render =~ product_1.name
    end

    defp search_form(lv, name) do
      lv
      |> form("[phx-submit=filter_by_product]", %{name: name})
      |> render_submit()
    end

    defp create_products do
      p1 = product_fixture()
      p2 = product_fixture(name: "Product 2")
      {p1, p2}
    end
  end
end
