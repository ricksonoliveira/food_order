defmodule FoodOrderWeb.Admin.ProductLive.Index do
  alias FoodOrder.Products
  use FoodOrderWeb, :live_view

  def mount(_, _, socket) do
    products = Products.list_products()
    {:ok, assign(socket, products: products)}
  end
end
