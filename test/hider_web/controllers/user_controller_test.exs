defmodule HiderWeb.UserControllerTest do
  use HiderWeb.ConnCase

  alias Hider.Accounts.User

  alias HiderWeb.UserView

  def to_safe_map(user) do
    user
    |> UserView.to_safe_map()
  end

  def to_map(user) do
    user
    |> Map.from_struct()
  end

  def to_string_keys(atom_map) do
    atom_map
    |> Enum.map(fn {k, v} -> {to_string(k), v} end)
    |> Enum.into(%{})
  end

  setup %{conn: conn} do
    [user: insert(:user), conn: put_req_header(conn, "accept", "application/json")]
  end

  describe "index" do
    test "lists all users", %{conn: conn, user: user} do
      user_json = user |> to_safe_map() |> to_string_keys()

      conn = get(conn, Routes.user_path(conn, :index))
      assert json_response(conn, 200)["data"] == [user_json]
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      user = :user |> build() |> to_map() |> Map.put(:password, "admin123")
      conn = post(conn, Routes.user_path(conn, :create), user: user)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => id,
               "cpf" => user.cpf,
               "email" => user.email,
               "username" => user.username,
               "first_name" => user.first_name,
               "last_name" => user.last_name,
               "middle_name" => user.middle_name,
               "rg" => user.rg
             } == json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = build(:user, password: nil, password_hash: nil) |> to_safe_map()
      conn = post(conn, Routes.user_path(conn, :create), user: user)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      new_middle_name = Faker.Person.PtBr.first_name()

      conn =
        put(conn, Routes.user_path(conn, :update, user), user: %{middle_name: new_middle_name})

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "middle_name" => ^new_middle_name
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: %{username: nil})
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end
  end
end
