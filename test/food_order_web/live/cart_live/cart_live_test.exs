defmodule FoodOrderWeb.CartLiveTest do
  use FoodOrderWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  setup %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/cart")

    {:ok, %{conn: conn, view: view}}
  end

  test "Load main elements when cart is empty", %{view: view} do
    assert has_element?(view, "[data-role=cart]")
    assert has_element?(view, "[data-role=cart]>div>h1", "Nothing here yet...")

    assert has_element?(
             view,
             "[data-role=cart]>div>p",
             "You're probably hungry, right?"
           )

    assert has_element?(
             view,
             "[data-role=cart]>div>p",
             "Order something from our menu!"
           )

    assert has_element?(view, "[data-role=cart]>div>a", "Go back")
  end

  # test "Loads main elements when cart has elements", %{view: view} do
  #   assert has_element?(view, "[data-role=cart]>div>div>h1", "Order Details")
  #   assert has_element?(view, "[data-role=item-image]")
  #   assert has_element?(view, "[data-role=item]>div>h1", "Pizza")
  #   assert has_element?(view, "[data-role=item]>div>span", "Small")
  #   assert has_element?(view, "[data-role=item]")
  #   assert has_element?(view, "[data-role=dec]", "-")
  #   assert has_element?(view, "[data-role=quantity]>div>span", "10 Item(s)")
  #   assert has_element?(view, "[data-role=add]", "+")
  #   assert has_element?(view, "[data-role=total-item]>span", "$100")
  #   assert has_element?(view, "[data-role=total-item]>button", "&times")
  #   assert has_element?(view, "[data-role=total-cart]")
  #   assert has_element?(view, "[data-role=total-cart]>div>span", "Total Amount:")
  #   assert has_element?(view, "[data-role=total-cart]>div>span", "$1000")
  #   assert has_element?(view, "[data-role=total-cart]>form>div>button", "Order now!")
  # end
end
