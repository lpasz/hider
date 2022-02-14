defmodule HiderWeb.UserLive.FormComponent do
  use HiderWeb, :live_component

  alias Hider.Accounts

  @impl true
  def update(%{user: user} = assigns, socket) do
    changeset = Accounts.change_user(user)

    socket
    |> assign(assigns)
    |> assign(:changeset, changeset)
    |> then(&{:ok, &1})
  end

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset =
      socket.assigns.user
      |> Accounts.change_user(parse_user_params(user_params))
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    save_user(socket, socket.assigns.action, user_params)
  end

  defp parse_user_params(user_params) do
    only_digits = &String.replace(&1, ~r/[^0-9]/, "")

    user_params
    |> Map.update("cpf", "", only_digits)
    |> Map.update("rg", "", only_digits)
  end

  defp save_user(socket, :edit, user_params) do
    user_params = parse_user_params(user_params)

    case Accounts.update_user(socket.assigns.user, user_params) do
      {:ok, _user} ->
        socket
        |> put_flash(:info, "User updated successfully")
        |> push_redirect(to: socket.assigns.return_to)
        |> then(&{:noreply, &1})

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_user(socket, :new, user_params) do
    case Accounts.create_user(user_params) do
      {:ok, _user} ->
        socket
        |> put_flash(:info, "User created successfully")
        |> push_redirect(to: socket.assigns.return_to)
        |> then(&{:noreply, &1})

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
