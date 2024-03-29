defmodule FoodOrderWeb.PageLiveTest do
  use FoodOrderWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import FoodOrder.ProductsFixtures

  test "load main hero html", %{conn: conn} do
    _product = product_fixture()
    {:ok, view, _html} = live(conn, ~p"/")

    hero_cta = "[data-role=hero-cta]"
    assert has_element?(view, "[data-role=hero]")
    assert has_element?(view, hero_cta)

    assert view |> element(hero_cta <> ">h6") |> render() =~ "Make your order"
    assert view |> element(hero_cta <> ">h1") |> render() =~ "Right now!"
    assert view |> element(hero_cta <> ">button") |> render() =~ "Order now"
    assert has_element?(view, "[data-role=hero-img]")
  end

  test "load products html", %{conn: conn} do
    _product = product_fixture()
    {:ok, view, _html} = live(conn, ~p"/")

    assert has_element?(view, "[data-role=products-section]")
    assert has_element?(view, "[data-role=products-section]>h1", "All foods")
    assert has_element?(view, "[data-role=products-list]")
  end

  test "load main item elements", %{conn: conn} do
    product = product_fixture()
    {:ok, view, _html} = live(conn, ~p"/")

    assert has_element?(view, "[data-role=item][data-id=#{product.id}]")
    assert has_element?(view, "[data-role=item][data-id=#{product.id}]>img")
    assert has_element?(view, "[data-role=item-details][data-id=#{product.id}]>h2", product.name)

    assert has_element?(
             view,
             "[data-role=item-details][data-id=#{product.id}]>span",
             Atom.to_string(product.size)
           )

    assert has_element?(
             view,
             "[data-role=item-details][data-id=#{product.id}]>div>span",
             Money.to_string(product.price)
           )

    assert view
           |> element("[data-role=item-details][data-id=#{product.id}]>div>button")
           |> render() =~ "Add"
  end

  test "infinite scroll loads more products when triggered", %{conn: conn} do
    products = for _ <- 0..12, do: product_fixture()

    {:ok, lv, _html} = live(conn, ~p"/")

    # We need to split the products into two pages, because the first page
    # is already loaded when the live view is mounted.
    [product_page_1, product_page_2] = Enum.chunk_every(products, 8)

    # Assert that the first page of products is loaded.
    Enum.each(product_page_1, fn product ->
      assert has_element?(lv, "[data-role=item][data-id=#{product.id}]")
    end)

    # Assert that the second page of products is not loaded.
    Enum.each(product_page_2, fn product ->
      refute has_element?(lv, "[data-role=item][data-id=#{product.id}]")
    end)

    # Trigger the load more products hook event.
    # Trigger twice to make sure that the hook is executed.
    lv
    |> element("#load_more_products")
    |> render_hook("load_more_products", %{})

    lv
    |> element("#load_more_products")
    |> render_hook("load_more_products", %{})

    # Assert that the second page of products is loaded.
    Enum.each(product_page_2, fn product ->
      assert has_element?(lv, "[data-role=item][data-id=#{product.id}]")
    end)

    # Assert that the first page of products is still loaded as well.
    Enum.each(product_page_1, fn product ->
      assert has_element?(lv, "[data-role=item][data-id=#{product.id}]")
    end)
  end

  test "add a new item on cart", %{conn: conn} do
    product = product_fixture()
    {:ok, view, _html} = live(conn, ~p"/")
    product_element = "[data-id=#{product.id}]>div>div>button"

    {:ok, _view, html} =
      view
      |> element(product_element)
      |> render_click()
      |> follow_redirect(conn, ~p"/")

    assert html =~ "Item added to cart"
  end
end
