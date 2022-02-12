defmodule Hider.AccountsTest do
  use Hider.DataCase

  alias Hider.Accounts
  alias Hider.Accounts.User

  describe "list_users/0" do
    test "returns all users" do
      user = insert(:user, password: nil)
      assert Accounts.list_users() == [user]
    end
  end

  describe "get_user!/1" do
    test "returns the user with given id" do
      user = insert(:user, password: nil)
      assert Accounts.get_user!(user.id) == user
    end
  end

  describe "create_user/1" do
    test "with valid data creates a user" do
      valid_attrs = build(:user, password_hash: nil) |> Map.from_struct()

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.cpf == valid_attrs.cpf
      assert user.first_name == valid_attrs.first_name
      assert user.last_name == valid_attrs.last_name
      assert user.middle_name == valid_attrs.middle_name
      assert user.rg == valid_attrs.rg
      assert Bcrypt.verify_pass(valid_attrs.password, user.password_hash)
    end

    test "with invalid data returns error changeset" do
      invalid_attrs = build(:user, password: nil, password_hash: nil) |> Map.from_struct()

      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(invalid_attrs)
    end
  end

  describe "update_user/2" do
    test "with valid data updates the user" do
      user = insert(:user)

      password = user.password

      update_attrs = build(:user, password: nil, password_hash: nil) |> Map.from_struct()

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.cpf == update_attrs.cpf
      assert user.first_name == update_attrs.first_name
      assert user.last_name == update_attrs.last_name
      assert user.middle_name == update_attrs.middle_name
      assert user.rg == update_attrs.rg
      assert Bcrypt.verify_pass(password, user.password_hash)
    end

    test "with invalid data returns error changeset" do
      user = insert(:user, password: nil)
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, %{username: nil})
      assert user == Accounts.get_user!(user.id)
    end
  end

  describe "delete_user/1" do
    test " deletes the user" do
      user = insert(:user)
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end
  end

  describe "change_user/1" do
    test "change_user/1 returns a user changeset" do
      user = insert(:user)
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
