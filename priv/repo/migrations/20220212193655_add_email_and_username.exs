defmodule Hider.Repo.Migrations.AddEmailAndUsername do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :email, :string
      add :username, :string
    end
  end
end
