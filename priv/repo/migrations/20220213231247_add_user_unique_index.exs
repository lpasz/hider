defmodule Hider.Repo.Migrations.AddUserUniqueIndex do
  use Ecto.Migration

  def change do
    create unique_index(:users, :cpf)
    create unique_index(:users, :email)
    create unique_index(:users, :rg)
    create unique_index(:users, :username)
  end
end
