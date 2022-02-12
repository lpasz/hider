defmodule HiderWeb.UserView do
  use HiderWeb, :view
  alias HiderWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      first_name: user.first_name,
      middle_name: user.middle_name,
      last_name: user.last_name,
      cpf: user.cpf,
      rg: user.rg,
      password_hash: user.password_hash
    }
  end
end
