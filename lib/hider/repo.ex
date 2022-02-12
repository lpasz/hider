defmodule Hider.Repo do
  use Ecto.Repo,
    otp_app: :hider,
    adapter: Ecto.Adapters.Postgres
end
