defmodule FoodOrderWeb.MainLive do
  use FoodOrderWeb, :live_view
  alias FoodOrderWeb.Client
  alias FoodOrderWeb.Main.ClientLive

  def mount(_assigns, _session, socket) do
    {:ok, assign(socket, clients: Client.all)}
  end

  def handle_info({:change_name, id, name}, socket) do
    send_update(ClientLive, id: id, name: name)
    {:noreply, socket}
  end
end
