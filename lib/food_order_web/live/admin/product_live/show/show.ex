defmodule FoodOrderWeb.Admin.ProductLive.Show do
  alias FoodOrder.Products
  alias FoodOrderWeb.Admin.ProductLive.Form
  use FoodOrderWeb, :live_view

  def handle_params(%{"id" => id}, _uri, socket) do
    product = Products.get_product!(id)
    {:noreply, assign(socket, :product, product) |> assign(:page_title, "Product #{product.id}")}
  end
end
