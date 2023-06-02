defmodule FoodOrderWeb.Admin.ProductLive.Index do
  alias FoodOrder.{Products, Products.Product}
  alias FoodOrderWeb.Admin.ProductLive.Form
  use FoodOrderWeb, :live_view

  def mount(_, _, socket) do
    products = Products.list_products()
    {:ok, assign(socket, products: products)}
  end

  def handle_params(params, _uri, socket) do
    live_action = socket.assigns.live_action
    {:noreply, apply_action(socket, live_action, params)}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    products = socket.assigns.products
    products |> Enum.find(&(&1.id == id)) |> Products.delete_product()
    delete_product = fn products -> Enum.filter(products, &(&1.id != id)) end
    {:noreply, update(socket, :products, &delete_product.(&1, id))}
  end

  defp apply_action(socket, :new, _params) do
    socket |> assign(:page_title, "New Product") |> assign(:product, %Product{})
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    product = Products.get_product!(id)
    socket |> assign(:page_title, "Edit Product") |> assign(:product, product)
  end

  defp apply_action(socket, :index, _params) do
    socket |> assign(:page_title, "List Products")
  end
end
