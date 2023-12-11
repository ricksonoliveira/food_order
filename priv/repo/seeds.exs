alias FoodOrder.{Accounts, Products}

for _ <- 0..50,
    do:
      Products.create_product(%{
        name:
          "#{Enum.random(["Hamburger", "Pizza", "Chicken Nuggets", "Fries"])} #{:rand.uniform(10_000)}",
        description: "bla bla bla",
        price: :rand.uniform(10_000),
        size: Enum.random([:SMALL, :MEDIUM, :LARGE]),
        image_url: "p-#{1..4 |> Enum.random()}.jpeg"
      })

Accounts.register_user(%{
  email: "admin@food.com",
  password: "Admin@food123",
  role: "ADMIN"
})

Accounts.register_user(%{
  email: "user@food.com",
  password: "User@food123",
  role: "USER"
})
