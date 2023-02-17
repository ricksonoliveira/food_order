defmodule FoodOrderWeb.MainLive do
  use FoodOrderWeb, :live_view

  def mount(_assigns, _session, socket) do
    {:ok, socket |> assign(name: "Rick", age: 25)}
  end
end