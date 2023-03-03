defmodule FoodOrderWeb.MainLive do
  use FoodOrderWeb, :live_view
  alias FoodOrderWeb.Client, as: ClientsList
  alias FoodOrderWeb.Main.Client

  def mount(_assigns, _session, socket) do
    {:ok, assign(socket, clients: ClientsList.all)}
  end

  def handle_info({:change_name, id, name}, socket) do
    send_update(Client, id: id, name: name)
    {:noreply, socket}
  end
end
