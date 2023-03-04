defmodule FoodOrderWeb.Client do
  def all,
    do: [
      %{
        id: Ecto.UUID.generate(),
        name: "Rick",
        value: 0
      },
      %{
        id: Ecto.UUID.generate(),
        name: "Ana",
        value: 0
      },
      %{
        id: Ecto.UUID.generate(),
        name: "Khaleesi",
        value: 0
      }
    ]
end
