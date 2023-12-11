defmodule FoodOrderWeb.Admin.ProductLive.Index do
  alias FoodOrder.{Products, Products.Product}
  alias FoodOrderWeb.Admin.ProductLive.Form
  use FoodOrderWeb, :live_view

  def handle_params(params, _uri, socket) do
    live_action = socket.assigns.live_action
    name = params["name"] || ""
    sort_by = (params["sort_by"] || "updated_at") |> String.to_atom()
    sort_order = (params["sort_order"] || "desc") |> String.to_atom()
    sort = %{sort_by: sort_by, sort_order: sort_order}
    products = Products.list_products(name: name, sort: sort)
    options = Map.merge(sort, %{name: name})
    assigns = [options: options, products: products, loading: false]

    socket =
      socket
      |> apply_action(live_action, params)
      |> assign(assigns)

    {:noreply, socket}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    products = socket.assigns.products
    products |> Enum.find(&(&1.id == id)) |> Products.delete_product()
    delete_product = fn products, id -> Enum.filter(products, &(&1.id != id)) end
    {:noreply, update(socket, :products, &delete_product.(&1, id))}
  end

  def handle_event("filter_by_product", %{"name" => name}, socket) do
    products = Products.list_products(name: name)
    socket = apply_filters(socket, name)
    {:noreply, socket |> assign(:products, products) |> assign(:name, name)}
  end

  def handle_info({:list_product, name}, socket) do
    params = [name: name]
    {:noreply, perform_filter(socket, params)}
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

  defp apply_filters(socket, name) do
    assings = [products: [], name: name, loading: true]
    send(self(), {:list_product, name})

    socket
    |> assign(assings)
    |> update(:options, &Map.put(&1, :name, name))
  end

  defp perform_filter(socket, params) do
    params
    |> Products.list_products()
    |> return_response(socket, params)
  end

  defp return_response([], socket, params) do
    assigns = [
      loading: false,
      products: []
    ]

    socket
    |> assign(assigns)
    |> update(:options, &Map.put(&1, :name, params[:name]))
    |> put_flash(:error, "No products found for #{params[:name]}")
  end

  defp return_response(products, socket, _params) do
    assigns = [loading: false, products: products]
    socket |> assign(assigns)
  end

  defp search_by_product(assigns) do
    ~H"""
    <form phx-submit="filter_by_product" action="" class="mr-4">
      <div class="relative">
        <span class="absolute inset-y-0 pl-2 left-0 flex items-center pt-5">
          <Heroicons.magnifying_glass solid class="h-6 w-6 stroke-current" />
        </span>
      </div>
      <input
        type="text"
        autocomplete="off"
        name="name"
        value={@name}
        placeholder="Search a product"
        class="pl-10 pr-1 py-3 text-gray-900 text-sm leading-tight border-gray-600 rounded-md border"
      />
    </form>
    """
  end
end
