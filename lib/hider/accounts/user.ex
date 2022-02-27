defmodule Hider.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hider.Crypt.AES
  alias Hider.Accounts.Trigram

  @cast_fields ~w(cpf email first_name last_name middle_name password password_confirmation rg username)a
  @required_fields ~w(cpf email first_name last_name middle_name rg username)a
  @encrypted_fields ~w(cpf email first_name last_name middle_name rg username)a

  schema "users" do
    field :cpf, :string
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :middle_name, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :rg, :string
    field :username, :string

    has_many :trigrams, Trigram

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @cast_fields)
    |> validate_passwords_match()
    |> validate_format(:email, ~r/@/)
    |> validate_length(:cpf, is: 11)
    |> validate_length(:rg, is: 10)
    |> validate_length(:username, max: 255)
    |> validate_length(:password, max: 255)
    |> validate_length(:password_confirmation, max: 255)
    |> unique_constraint(:email)
    |> unique_constraint(:username)
    |> unique_constraint(:cpf)
    |> unique_constraint(:rg)
    |> validate_required(@required_fields)
  end

  defp validate_passwords_match(changeset) do
    get_change = &get_change(changeset, &1)

    case {get_change.(:password), get_change.(:password_confirmation)} do
      {nil, _} ->
        changeset

      {_, nil} ->
        changeset

      {password, password} ->
        changeset

      _ ->
        changeset
        |> add_error(:password, "password's must match")
        |> add_error(:password_confirmation, "password's must match")
    end
  end

  def maybe_put_password_hash(changeset) do
    case get_field(changeset, :password_hash) do
      nil -> put_password_hash(changeset)
      _ -> changeset
    end
  end

  defp put_password_hash(changeset) do
    if password = get_field(changeset, :password) do
      salt = Bcrypt.Base.gen_salt()
      password_hash = Bcrypt.Base.hash_password(password, salt)

      put_change(changeset, :password_hash, password_hash)
    else
      validate_required(changeset, :password)
    end
  end

  def put_encrypt(changeset) do
    Enum.reduce(@encrypted_fields, changeset, fn field, changeset ->
      changeset
      |> get_field(field)
      |> AES.encrypt()
      |> then(&put_change(changeset, field, &1))
    end)
  end

  def decrypt(user, fields \\ []) do
    fields
    |> then(fn
      :all -> @encrypted_fields
      _ -> fields
    end)
    |> List.wrap()
    |> Enum.reduce(user, fn
      field, user when field in @encrypted_fields ->
        user
        |> Map.get(field)
        |> AES.decrypt()
        |> then(&Map.put(user, field, &1))

      _, user ->
        user
    end)
  end
end
