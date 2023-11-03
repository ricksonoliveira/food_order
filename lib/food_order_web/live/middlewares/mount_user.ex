defmodule FoodOrderWeb.MountUser do
  @moduledoc """
  Mounts the current user to the socket.
  """

  alias FoodOrder.Accounts

  @doc """
  Mounts the current user to the socket.
  """
  def mount_current_user(session, socket) do
    Phoenix.Component.assign_new(socket, :current_user, fn ->
      if user_token = session["user_token"] do
        Accounts.get_user_by_session_token(user_token)
      end
    end)
  end
end
