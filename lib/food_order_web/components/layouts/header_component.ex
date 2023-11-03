defmodule FoodOrderWeb.HeaderComponent do
  use FoodOrderWeb, :html

  def menu(assigns) do
    ~H"""
      <nav class="flex items-center justify-between py-4">
        <a href="/" id="logo">
          <img src={~p"/images/logo.png"} alt="" class="h-16 w-25">
        </a>
        <ul class="flex items-center">
        <%= if @current_user do %>

          <%= if @current_user.role == :ADMIN do %>
            <li class="ml-6">
              <.link
                  href={~p"/admin/products"}
                  class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
                >
                  Admin Products
                </.link>
            </li>
            <li class="ml-6 text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700">
              Admin Orders
            </li>
          <% else %>
            <li class="ml-6 text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700">
              My Orders
            </li>
          <% end %>
          <ul class="relative z-10 flex items-center gap-4 px-4 sm:px-6 lg:px-8 justify-end">
            <li>
              <.link
                href={~p"/users/settings"}
                class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
              >
                Settings
              </.link>
            </li>
            <li>
            <span class="ml-3 text-fuchsia-500 text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"><%= @current_user.email %></span>
              <.link
                href={~p"/users/log_out"}
                method="delete"
                class="ml-6 text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
              >
                Log out
              </.link>
            </li>
          </ul>
          <a href={~p"/cart"} class="ml-6 p-6 bg-fuchsia-500 rounded-full text-neutral-100 flex group hover:text-fuchsia-500 hover:bg-fuchsia-300 transition">
            <span class="text-xs">0</span>
            <Heroicons.shopping_cart solid class="h-5 w-5 stroke-current" />
          </a>
          <% else %>
            <li class="ml-6">
              <.link href={~p"/users/register"}>
                Register
              </.link>
            </li>
            <li class="ml-6">
              <.link href={~p"/users/log_in"}>
                Log in
              </.link>
            </li>
          <% end %>
        </ul>
      </nav>
    """
  end
end
