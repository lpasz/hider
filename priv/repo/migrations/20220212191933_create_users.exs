defmodule Hider.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :middle_name, :string
      add :last_name, :string
      add :cpf, :string
      add :rg, :string
      add :password_hash, :string

      timestamps()
    end
  end
end
