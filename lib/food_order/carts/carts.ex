defmodule FoodOrder.Carts do
  @name :cart_session

  def create(cart_id), do: GenServer.cast(@name, {:create, cart_id})
  def add(cart_id, product), do: GenServer.cast(@name, {:add, cart_id, product})
  def get(cart_id), do: GenServer.call(@name, {:get, cart_id})
  def increment(cart_id, product_id), do: GenServer.call(@name, {:increment, cart_id, product_id})
  def decrement(cart_id, product_id), do: GenServer.call(@name, {:decrement, cart_id, product_id})
  def remove(cart_id, product_id), do: GenServer.call(@name, {:remove, cart_id, product_id})
end
