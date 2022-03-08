defmodule HiderWeb.UserLive.Show do
  use HiderWeb, :live_view

  alias Hider.Accounts
  import HiderWeb.UserView

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:user, id |> Accounts.get_user!() |> decrypt())
     |> then(&{:noreply, &1})
  end

  defp page_title(:show), do: "Show User"
  defp page_title(:edit), do: "Edit User"
end
