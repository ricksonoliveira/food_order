defmodule FoodOrder.Carts.Server.CartSession do
  use GenServer

  import FoodOrder.Carts.Core.HandleCarts

  @name :cart_session

  def start_link(_), do: GenServer.start_link(__MODULE__, @name, name: @name)

  def init(name) do
    :ets.new(name, [:set, :public, :named_table])
    {:ok, name}
  end

  def handle_cast({:create, cart_id}, name) do
    case find_cart(name, cart_id) do
      {:error, []} -> :ets.insert(name, {cart_id, create(cart_id)})
      {:ok, _cart} -> :ok
    end

    {:noreply, name}
  end

  def handle_cast({:add, cart_id, product}, name) do
    {:ok, cart} = find_cart(name, cart_id)
    cart = add(cart, product)
    :ets.insert(name, {cart_id, cart})

    {:noreply, name}
  end

  def handle_call({:get, cart_id}, _from, name) do
    {:ok, cart} = find_cart(name, cart_id)
    {:reply, cart, name}
  end

  def handle_call({:increment, cart_id, product_id}, _from, name) do
    {:ok, cart} = find_cart(name, cart_id)
    cart = increment(cart, product_id)
    :ets.insert(name, {cart_id, cart})
    {:reply, cart, name}
  end

  def handle_call({:decrement, cart_id, product_id}, _from, name) do
    {:ok, cart} = find_cart(name, cart_id)
    cart = decrement(cart, product_id)
    :ets.insert(name, {cart_id, cart})
    {:reply, cart, name}
  end

  def handle_call({:remove, cart_id, product_id}, _from, name) do
    {:ok, cart} = find_cart(name, cart_id)
    cart = remove(cart, product_id)
    :ets.insert(name, {cart_id, cart})
    {:reply, cart, name}
  end

  defp find_cart(name, cart_id) do
    case :ets.lookup(name, cart_id) do
      [] -> {:error, []}
      [{_cart_id, cart}] -> {:ok, cart}
    end
  end
end
