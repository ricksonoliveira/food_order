defmodule FoodOrderWeb.PageLive do
  alias FoodOrder.Products
  use FoodOrderWeb, :live_view
  alias FoodOrderWeb.PageLive.Item

  def mount(_, _, socket) do
    socket =
      socket
      |> assign(page: 1, per_page: 8)
      |> assign_list_products()

    {:ok, socket}
  end

  def handle_event("load_more_products", _params, socket) do
    socket =
      socket
      |> update(:page, &(&1 + 1))
      |> assign_list_products()

    {:noreply, socket}
  end

  defp assign_list_products(socket) do
    page = socket.assigns.page
    per_page = socket.assigns.per_page
    paginate = [{:paginate, %{page: page, per_page: per_page}}]
    assign(socket, products: Products.list_products(paginate))
  end
end
