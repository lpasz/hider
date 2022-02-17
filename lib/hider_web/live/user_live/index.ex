defmodule HiderWeb.UserLive.Index do
  use HiderWeb, :live_view

  alias Hider.Accounts
  alias Hider.Accounts.User

  @impl true
  def mount(_params, _session, socket) do
    socket
    |> assign(:users, list_users())
    |> assign(:search, %{search: ""})
    |> then(fn socket -> {:ok, socket} end)
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit User")
    |> assign(:user, Accounts.get_user!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New User")
    |> assign(:user, %User{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Users")
    |> assign(:user, nil)
  end

  def handle_event("search", %{"search" => %{"search" => cpf}}, socket) do
    {:noreply, assign(socket, :users, [search(cpf)])}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user = Accounts.get_user!(id)
    {:ok, _} = Accounts.delete_user(user)

    {:noreply, assign(socket, :users, list_users())}
  end

  defp list_users do
    Accounts.list_users()
  end

  defp search(cpf) do
    Accounts.get_user_by_cpf(cpf)
  end
end
