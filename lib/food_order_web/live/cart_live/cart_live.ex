defmodule FoodOrderWeb.CartLive do
  use FoodOrderWeb, :live_view

  alias FoodOrder.{Carts, Products}
  alias FoodOrderWeb.CartLive.Details

  def mount(_, _, socket) do
    uuid = Ecto.UUID.generate()
    Carts.create(uuid)
    product = Products.list_products() |> hd
    Carts.add(uuid, product)
    cart = Carts.get(uuid)
    {:ok, assign(socket, cart: cart)}
  end

  defp empty_cart(assigns) do
    ~H"""
      <div class="py-16 container mx-auto text-center" >
        <h1 class="text-3xl font-bold mb-2">Nothing here yet...</h1>
        <p class="text-neutral-500 text-lg mb-12">
          You're probably hungry, right? <br /> Order something from our menu!
        </p>
        <Heroicons.shopping_bag solid class="w-20 h-20 mx-auto text-fuchsia-500" />
        <a href={~p"/"} class="inline-block px-6 py-2 rounded-full bg-fuchsia-500 text-white font-bold mt-12">Go back</a>
      </div>
    """
  end
end
