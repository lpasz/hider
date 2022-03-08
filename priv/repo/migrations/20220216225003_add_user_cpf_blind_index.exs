defmodule Hider.Repo.Migrations.AddUserCpfBlindIndex do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :cpf_blind, :string
    end

    create unique_index(:users, :cpf_blind)
  end
end
