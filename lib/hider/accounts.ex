defmodule Hider.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false

  alias Ecto.Multi
  alias Hider.Accounts.Trigram
  alias Hider.Accounts.User
  alias Hider.Repo

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Fuzzy Full Text Search for user
  """
  def fuzzy_search(text) do
    trigrams = Trigram.make_trigrams(text)

    Trigram
    |> where([t], t.trigram in ^trigrams)
    |> distinct([t], t.user_id)
    |> preload(:user)
    |> Repo.all()
    |> Enum.map(& &1.user)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user_by_cpf(cpf) do
    cpf
    |> Hider.Crypt.Argon2.hash()
    |> then(fn cpf_hash ->
      Repo.get_by(User, cpf_blind: cpf_hash)
    end)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    Multi.new()
    |> Multi.put(:attrs, attrs)
    |> Multi.insert(:user, &do_create_user_changeset/1)
    |> Multi.insert_all(:trigrams, Trigram, &do_create_trigrams/1)
    |> Repo.transaction(timeout: 600_000)
    |> then(fn
      {:ok, %{user: user}} -> {:ok, user}
      {:error, _, reason, _} -> {:error, reason}
    end)
  end

  defp do_create_user_changeset(changes) do
    %User{}
    |> User.changeset(changes.attrs)
    |> User.maybe_put_password_hash()
    |> User.put_encrypt_cpf()
  end

  defp do_create_trigrams(changes) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    changes.user
    |> Map.from_struct()
    |> Enum.reduce([], fn {key, val}, acc ->
      cond do
      key in ~w(email first_email middle_name last_name cpf rg)a ->
        trigrams =
          val
          |> Trigram.make_trigrams()
          |> Enum.map(&%{trigram: &1, user_id: changes.user.id, updated_at: now, inserted_at: now})

        trigrams ++ acc

      true ->
        acc
      end
    end)
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
