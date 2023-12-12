defmodule FoodOrderWeb.Admin.PageLive.IndexTest do
  use FoodOrderWeb.ConnCase, async: true
  import Phoenix.LiveViewTest
  import FoodOrder.ProductsFixtures

  describe "index" do
    setup [:create_product, :register_and_log_in_admin]

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

      assert view |> element("header>div>div>a", "New Product") |> render_click()

      assert_patch(view, ~p"/admin/products/new")

      assert view |> has_element?("#new-product-modal")

      assert view
             |> form("#product-form", product: %{})
             |> render_change() =~ "be blank"

      {:ok, _view, html} =
        view
        |> form("#product-form",
          product: %{
            name: "Product 1",
            description: "some description",
            price: "10"
          }
        )
        |> render_submit()
        |> follow_redirect(conn, ~p"/admin/products")

      assert html =~ "Product created successfully!"
      assert html =~ "Product 1"
    end

    test "updates product from listing", %{conn: conn, product: product} do
      {:ok, view, _html} = live(conn, ~p"/admin/products")

      assert view
             |> element("#products-#{product.id}>td>div>span>div>a", "Edit")
             |> render_click()

      assert_patch(view, ~p"/admin/products/#{product.id}/edit")

      {:ok, _view, html} =
        view
        |> form("#product-form",
          product: %{
            name: "Product 1 updated",
            description: "some description",
            price: "10"
          }
        )
        |> render_submit()
        |> follow_redirect(conn, ~p"/admin/products")

      assert html =~ "Product updated successfully!"
      assert html =~ "Product 1 updated"
    end

    test "updates product within modal", %{conn: conn, product: product} do
      {:ok, view, _html} = live(conn, ~p"/admin/products/#{product}")

      assert view
             |> element("a", "Edit")
             |> render_click() =~ "Edit"

      assert_patch(view, ~p"/admin/products/#{product}/show/edit")

      assert view
             |> form("#product-form", product: %{description: nil})
             |> render_submit() =~ "be blank"

      {:ok, _view, html} =
        view
        |> form("#product-form",
          product: %{
            name: "Product 1 updated",
            description: "some description updated",
            price: "10"
          }
        )
        |> render_submit()
        |> follow_redirect(conn, ~p"/admin/products/#{product}")

      assert html =~ "Product updated successfully!"
      assert html =~ "some description updated"
    end

    test "Delete product", %{conn: conn, product: product} do
      {:ok, view, _html} = live(conn, ~p"/admin/products")

      assert has_element?(view, "header>div>h1", "List Products")

      product_id_el = "#products-#{product.id}"

      view
      |> element(product_id_el <> ">td>div>span>div>a", "Delete")
      |> render_click()

      refute has_element?(view, product_id_el)
    end
  end

  describe "sort" do
    setup [:create_product, :register_and_log_in_admin]

    test "sort using poduct name", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/admin/products")

      view |> element("th>a", "Name") |> render_click()
      assert_patched(view, ~p"/admin/products?name=&sort_by=name&sort_order=asc&")
      view |> element("th>a", "Name") |> render_click()
      assert_patched(view, ~p"/admin/products?name=&sort_by=name&sort_order=desc&")
    end
  end

  defp create_product(_conn) do
    product = product_fixture()
    %{product: product}
  end
end
