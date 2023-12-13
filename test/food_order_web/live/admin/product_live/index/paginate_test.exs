defmodule FoodOrderWeb.Admin.ProductLive.PaginateTest do
  use FoodOrderWeb.ConnCase, async: true
  import FoodOrder.ProductsFixtures
  import Phoenix.LiveViewTest

  describe "paginate component" do
    setup [:register_and_log_in_admin]

    test "click next, previews and page", %{conn: conn} do
      product_fixture()
      # Visit the admin products page
      {:ok, lv, _html} = live(conn, ~p"/admin/products")

      # Assert that the pagination component is present
      assert has_element?(lv, "#pagination")

      # Assert that clicking next, previews and page works
      lv
      |> element("[data-role=next]")
      |> render_click()

      assert path = assert_patch(lv)
      assert path =~ "/admin/products"
      assert path =~ "&page=2"

      lv
      |> element("[data-role=previous]")
      |> render_click()

      assert path = assert_patch(lv)
      assert path =~ "/admin/products"
      assert path =~ "&page=1"

      lv
      |> element("#pagination>div>div>a", "2")
      |> render_click()

      assert path = assert_patch(lv)
      assert path =~ "/admin/products"
      assert path =~ "&page=2"
    end

    test "using params", %{conn: conn} do
      p1 = product_fixture()
      p2 = product_fixture(name: "Product 2")

      # Visit the admin products page
      {:ok, lv, _html} =
        live(
          conn,
          ~p"/admin/products?name=&page=1&per_page=1&sort_by=inserted_at&sort_order=desc"
        )

      # Assert renders the first product is present and the second isn't
      assert has_element?(lv, "#products-#{p1.id}")
      refute has_element?(lv, "#products-#{p2.id}")
    end
  end
end
