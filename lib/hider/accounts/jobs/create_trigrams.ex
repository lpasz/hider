defmodule Hider.Accounts.Jobs.CreateTrigrams do
  use Oban.Worker, queue: :events

  alias Hider.Accounts
  alias Hider.Accounts.Trigram
  alias Hider.Accounts.User
  alias Hider.Repo

  @impl Oban.Worker
  def perform(job) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    job.args.user_id
    |> Accounts.get_user!()
    |> User.decrypt(:all)
    |> Map.from_struct()
    |> Enum.reduce([], fn {key, val}, acc ->
      cond do
      key in ~w(email first_email middle_name last_name cpf rg username)a ->
        trigrams =
          val
          |> Trigram.make_trigrams()
          |> Enum.map(&%{trigram: &1, user_id: job.args.user_id, updated_at: now, inserted_at: now})

        trigrams ++ acc

      true ->
        acc
      end
    end)
    |> then(fn inserts -> Hider.Repo.insert_all(Trigram, inserts) end)
  end
end
