defmodule FoodOrder.Carts.Core.HandleCarts do
  alias FoodOrder.Carts.Data.Cart

  @doc """
  Create a new cart session

  ## Examples

      iex> FoodOrder.Carts.Core.HandleCarts.create(444_444)
      %Cart{
        id: 444_444,
        items: [],
        total_price: %Money{amount: 0, currency: :USD},
        total_qty: 0
      }
  """
  def create(cart_id) do
    Cart.new(cart_id)
  end

  @doc """
  Add a new item to the cart

  ## Examples

      iex> FoodOrder.Carts.Core.HandleCarts.add(cart, product)
      %Cart{
        id: 444_444,
        items: [%{item: product, qty: 1}],
        total_price: product.price,
        total_qty: 1
      }
  """
  def add(cart, item) do
    new_total_price = Money.add(cart.total_price, item.price)
    new_items = new_item(cart.items, item)

    %{
      cart
      | total_qty: cart.total_qty + 1,
        items: new_items,
        total_price: new_total_price
    }
  end

  defp new_item(items, item) do
    is_there_item_id? = Enum.find(items, &(item.id == &1.item.id))

    if is_there_item_id? == nil do
      items ++ [%{item: item, qty: 1}]
    else
      items
      |> Map.new(fn item -> {item.item.id, item} end)
      |> Map.update!(item.id, &%{&1 | qty: &1.qty + 1})
      |> Map.values()
    end
  end

  @doc """
  Remove an item from the cart

  ## Examples

      iex> FoodOrder.Carts.Core.HandleCarts.remove(cart, product.id)
      %Cart{
        id: 444_444,
        items: [%{item: product, qty: 1}],
        total_price: product.price,
        total_qty: 1
      }
  """
  def remove(cart, item_id) do
    {items, item_removed} = Enum.reduce(cart.items, {[], nil}, &remove_item(&1, &2, item_id))
    total_price_to_deduct = Money.multiply(item_removed.item.price, item_removed.qty)
    total_price = Money.subtract(cart.total_price, total_price_to_deduct)

    %{cart | items: items, total_qty: cart.total_qty - item_removed.qty, total_price: total_price}
  end

  defp remove_item(item, acc, item_id) do
    {list, item_acc} = acc

    if item.item.id == item_id do
      {list, item}
    else
      {[item | list], item_acc}
    end
  end

  @doc """
  Increment an item from the cart

  ## Examples

      iex> FoodOrder.Carts.Core.HandleCarts.increment(cart, product.id)
      %Cart{
        id: 444_444,
        items: [%{item: product, qty: 2}],
        total_price: product.price,
        total_qty: 2
      }
  """
  def increment(%{items: items} = cart, item_id) do
    {items_updated, product} =
      Enum.reduce(items, {[], nil}, fn item_detail, acc ->
        {list, item} = acc

        if item_detail.item.id == item_id do
          updated_item = %{item_detail | qty: item_detail.qty + 1}
          item_updated = [updated_item]
          {[list | item_updated], updated_item}
        else
          {[item_detail | list], item}
        end
      end)

    total_price = Money.add(cart.total_price, product.item.price)
    %{cart | items: items_updated, total_qty: cart.total_qty + 1, total_price: total_price}
  end

  @doc """
  Decrement an item from the cart

  ## Examples

      iex> FoodOrder.Carts.Core.HandleCarts.decrement(cart, product.id)
      %Cart{
        id: 444_444,
        items: [%{item: product, qty: 1}],
        total_price: product.price,
        total_qty: 1
      }
  """
  def decrease(%{items: items} = cart, item_id) do
    {items_updated, product} =
      Enum.reduce(items, {[], nil}, fn item_detail, acc ->
        {list, item} = acc

        if item_detail.item.id == item_id do
          updated_item = %{item_detail | qty: item_detail.qty - 1}

          if updated_item.qty == 0 do
            {list, updated_item}
          else
            item_updated = [updated_item]
            {list ++ item_updated, updated_item}
          end
        else
          {[item_detail | list], item}
        end
      end)

    total_price = Money.subtract(cart.total_price, product.item.price)
    %{cart | items: items_updated, total_qty: cart.total_qty - 1, total_price: total_price}
  end
end
