defmodule FoodOrder.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  alias FoodOrder.Carts.Server.CartSession

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      FoodOrder.Repo,
      # Start the Telemetry supervisor
      FoodOrderWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: FoodOrder.PubSub},
      # Start Finch
      {Finch, name: FoodOrder.Finch},
      # Start the Endpoint (http/https)
      FoodOrderWeb.Endpoint,
      CartSession
      # Start a worker by calling: FoodOrder.Worker.start_link(arg)
      # {FoodOrder.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FoodOrder.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FoodOrderWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
