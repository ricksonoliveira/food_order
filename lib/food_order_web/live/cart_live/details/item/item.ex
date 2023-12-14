defmodule FoodOrderWeb.CartLive.Details.Item do
  use FoodOrderWeb, :live_component

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
          <button data-role="dec" class="p-1 m-2 rounded-full text-white font-bold bg-fuchsia-500">-</button>
          <span><%= @item.qty %> Item(s)</span>
          <button data-role="add" class="p-1 m-2 rounded-full text-white font-bold bg-fuchsia-500">+</button>
        </div>
      </div>

      <div class="flex flex-1 items-center" data-role="total-item">
        <span class="font-bold text-lg"><%= @item.item.price %></span>
        <button class="ml-2 w-6 h-6 rounded-full text-white bg-fuchsia-500 font-bold">
          &times
        </button>
      </div>
    </div>
    """
  end
end
