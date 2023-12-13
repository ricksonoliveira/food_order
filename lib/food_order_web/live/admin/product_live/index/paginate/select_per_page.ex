defmodule FoodOrderWeb.Admin.ProductLive.Index.SelectPerPage do
  use FoodOrderWeb, :live_component

  def render(assigns) do
    ~H"""
    <form id={@id} phx-change="update_per_page" phx-target={@myself} class="flex pr-6">
      <select name="per-page-select">
        <option value="5">5</option>
        <option value="10">10</option>
        <option value="20">20</option>
      </select>
    </form>
    """
  end

  def handle_event("update_per_page", %{"per-page-select" => per_page}, socket) do
    options = socket.assigns.options
    url = ~p"/admin/products?#{Map.put(options, :per_page, per_page)}"
    {:noreply, push_patch(socket, to: url)}
  end
end
