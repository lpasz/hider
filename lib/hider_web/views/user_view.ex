defmodule HiderWeb.UserView do
  use HiderWeb, :view
  alias HiderWeb.UserView
  alias Hider.Accounts.User
  alias Hider.Crypt.AES

  def decrypt(value) do
    case value do
      users when is_list(users) -> Enum.map(users, &decrypt/1)
      %User{} = user -> Map.put(user, :cpf, decrypt(user.cpf))
      cpf -> AES.decrypt(cpf)
    end
  end

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    to_safe_map(user)
  end

  def to_safe_map(user) do
    %{
      id: user.id,
      cpf: user.cpf,
      email: user.email,
      first_name: user.first_name,
      last_name: user.last_name,
      middle_name: user.middle_name,
      rg: user.rg,
      username: user.username
    }
  end
end
