defmodule Hider.Repo.Migrations.Trigrams do
  use Ecto.Migration

  def change do
    create table(:trigrams) do
      add :trigram, :string
      add :user_id, references(:users)

      timestamps()
    end

    create index(:trigrams, :trigram)
  end
end
