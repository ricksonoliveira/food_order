defmodule FoodOrderWeb.PageLive.Item do
  use FoodOrderWeb, :live_component

  defp product_detail(assigns) do
    ~H"""
    <h2 class="mb-4 text-lg"><%= @name %></h2>
    <span class="bg-neutral-200 py-1 px-4 rounded-full uppercase text-xs">
      <%= @size %>
    </span>
    """
  end

  defp product_info(assigns) do
    ~H"""
    <div class="mt-6 flex items-center justify-around">
      <span class="font-bold text-lg"><%= @price %></span>
      <button class="border-2 py-1 px-6 rounded-full border-fuchsia-500 text-fuchsia-500 transition hover:bg-fuchsia-500 hover:text-neutral-100">
        <span>Add</span>
        <span>+</span>
      </button>
    </div>
    """
  end
end
