defmodule FoodOrderWeb.Admin.ProductLive.SelectPerPageTest do
  use FoodOrderWeb.ConnCase, async: true
  import FoodOrder.ProductsFixtures
  import Phoenix.LiveViewTest

  describe "select per page component" do
    setup [:register_and_log_in_admin]

    test "select to fetch 20 items per page", %{conn: conn} do
      product_fixture()
      # Visit the admin products page
      {:ok, lv, _html} = live(conn, ~p"/admin/products")

      # Assert that selecting 20 items per page will send a patch request
      # and render the index page with 20 items per page
      lv
      |> form("#select-per-page", %{"per-page-select" => "20"})
      |> render_change()

      # assert_patched(
      #   lv,
      #   ~p"/admin/products?name=&sort_by=updated_at&page=1&sort_order=desc&per_page=20"
      # )
      assert path = assert_patch(lv)
      assert path =~ "/admin/products"
      assert path =~ "&per_page=20"
    end
  end
end
