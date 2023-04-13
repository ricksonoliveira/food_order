defmodule FoodOrderWeb.Admin.ProductLive.Index do
  alias FoodOrder.{Products, Products.Product}
  alias FoodOrderWeb.Admin.ProductLive.Form
  use FoodOrderWeb, :live_view

  def mount(_, _, socket) do
    products = Products.list_products()
    {:ok, assign(socket, products: products)}
  end
  def handle_params(_params, _uri, socket) do
    live_action = socket.assigns.live_action
    {:noreply, apply_action(socket, live_action)}
  end

  defp apply_action(socket, :new) do
    socket |> assign(:page_title, "New Product") |> assign(:product, %Product{})
  end

  defp apply_action(socket, :index) do
    socket |> assign(:page_title, "List Products")
  end
end