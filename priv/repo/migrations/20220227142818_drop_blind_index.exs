defmodule Hider.Repo.Migrations.DropBlindIndex do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :cpf_blind
    end
  end
end
