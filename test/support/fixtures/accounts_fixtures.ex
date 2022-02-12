defmodule Hider.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Hider.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        cpf: "some cpf",
        first_name: "some first_name",
        last_name: "some last_name",
        middle_name: "some middle_name",
        password_hash: "some password_hash",
        rg: "some rg"
      })
      |> Hider.Accounts.create_user()

    user
  end
end
