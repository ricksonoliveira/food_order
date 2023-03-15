defmodule FoodOrderWeb.PageLiveTest do
  use FoodOrderWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  setup %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/")

    {:ok, %{conn: conn, view: view}}
  end

  test "load main hero html", %{view: view} do
    hero_cta = "[data-role=hero-cta]"
    assert has_element?(view, "[data-role=hero]")
    assert has_element?(view, hero_cta)

    assert view |> element(hero_cta <> ">h6") |> render() =~ "Make your order"
    assert view |> element(hero_cta <> ">h1") |> render() =~ "Right now!"
    assert view |> element(hero_cta <> ">button") |> render() =~ "Order now"
    assert has_element?(view, "[data-role=hero-img]")
  end

  test "load products html", %{view: view} do
    assert has_element?(view, "[data-role=products-section]")
    assert has_element?(view, "[data-role=products-section]>h1", "All foods")
    assert has_element?(view, "[data-role=products-list]")
  end

  test "load main item elements", %{view: view} do
    assert has_element?(view, "[data-role=item][data-id=1]")
    assert has_element?(view, "[data-role=item][data-id=1]>img")
    assert has_element?(view, "[data-role=item-details][data-id=1]>h2", "Product Name")
    assert has_element?(view, "[data-role=item-details][data-id=1]>span", "small")
    assert has_element?(view, "[data-role=item-details][data-id=1]>div>span", "$10")
    assert view |> element("[data-role=item-details][data-id=1]>div>button") |> render()  =~ "Add"
  end
end
