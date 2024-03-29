defmodule FoodOrderWeb.CartLive.Details.Item do
  use FoodOrderWeb, :live_component

  alias FoodOrder.Carts

  def render(assigns) do
    ~H"""
    <div id={@id} data-role="item" class="flex items-center my-8 shadow-lg p-2 hover:bg-neutral-100">
      <img data-role="item-image" src={~p"/images/products/#{@item.item.image_url}"} alt="" class="h-16 w-16 rounded-full"/>

      <div class="flex-1 ml-4">
        <h1><%= @item.item.name %></h1>
        <span><%= @item.item.size %></span>
      </div>

      <div class="flex-1" data-role="quantity">
        <div class="flex items-center">
          <button data-role="dec" phx-click="dec" phx-target={@myself} data-id={@id} class="p-1 m-2 rounded-full text-white font-bold bg-fuchsia-500">-</button>
          <span data-role="items" data-id={@id}><%= @item.qty %> Item(s)</span>
          <button data-role="inc" data-role="add" phx-click="inc" phx-target={@myself} data-id={@id} class="p-1 m-2 rounded-full text-white font-bold bg-fuchsia-500">+</button>
        </div>
      </div>

      <div class="flex flex-1 items-center" data-role="total-item">
        <span data-role="price" data-id={@id} class="font-bold text-lg"><%= @item.item.price %></span>
        <button data-role="remove" phx-click="remove" phx-target={@myself} data-id={@id} class="ml-2 w-6 h-6 rounded-full text-white bg-fuchsia-500 font-bold">
          &times
        </button>
      </div>
    </div>
    """
  end

  def handle_event("remove", _, socket) do
    update_cart(socket, &Carts.remove/2)
    {:noreply, socket}
  end

  def handle_event("dec", _, socket) do
    update_cart(socket, &Carts.decrement/2)
    {:noreply, socket}
  end

  def handle_event("inc", _, socket) do
    update_cart(socket, &Carts.increment/2)
    {:noreply, socket}
  end

  defp update_cart(socket, fun) do
    product_id = socket.assigns.id
    cart_id = socket.assigns.cart_id
    cart = fun.(cart_id, product_id)
    send(self(), {:update, cart})
  end
end
