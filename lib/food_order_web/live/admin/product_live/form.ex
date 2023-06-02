defmodule FoodOrderWeb.Admin.ProductLive.Form do
  use FoodOrderWeb, :live_component
  alias FoodOrder.Products

  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        for={@form}
        id="product-form"
        phx-change="validate"
        phx-target={@myself}
        phx-submit="save"
      >
        <.input field={@form[:name]} label="Name" />
        <.input field={@form[:description]} type="textarea" label="Description" />
        <.input field={@form[:price]} label="Price" />

        <:actions>
          <.button phx-disable-with="Saving...">Save Product</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def update(%{product: product} = assigns, socket) do
    changeset = Products.change_product(product)
    {:ok, socket |> assign(assigns) |> assign_form(changeset)}
  end

  def handle_event(
        "validate",
        %{"product" => product_params},
        %{assigns: %{product: product}} = socket
      ) do
    changeset =
      product
      |> Products.change_product(product_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"product" => product_params}, socket) do
    save(socket, socket.assigns.action, product_params)
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp save(socket, :new, product_params) do
    Products.create_product(product_params)
    |> perform_save_action(socket, "Product created successfully!")
  end

  defp save(socket, :edit, product_params) do
    Products.update_product(socket.assigns.product, product_params)
    |> perform_save_action(socket, "Product updated successfully!")
  end

  defp perform_save_action(action_result, socket, message) do
    case action_result do
      {:ok, _} ->
        socket =
          socket
          |> put_flash(:info, message)
          |> push_navigate(to: socket.assigns.navigate)

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end
end
