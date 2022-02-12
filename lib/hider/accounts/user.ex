defmodule Hider.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @cast_fields ~w(cpf email first_name last_name middle_name password rg username)a
  @required_fields ~w(cpf email first_name last_name middle_name password_hash rg username)a

  schema "users" do
    field :cpf, :string
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :middle_name, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :rg, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @cast_fields)
    |> maybe_put_password_hash()
    |> validate_required(@required_fields)
  end

  defp put_password_hash(changeset) do
    if password = get_field(changeset, :password) do
      salt = Bcrypt.Base.gen_salt()
      password_hash = Bcrypt.Base.hash_password(password, salt)

      changeset
      |> put_change(:password, nil)
      |> put_change(:password_hash, password_hash)
    else
      validate_required(changeset, :password)
    end
  end

  defp maybe_put_password_hash(changeset) do
    case get_field(changeset, :password_hash) do
      nil -> put_password_hash(changeset)
      _ -> put_change(changeset, :password, nil)
    end
  end
end
