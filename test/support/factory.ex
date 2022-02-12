defmodule Hider.Factory do
  use ExMachina.Ecto, repo: Hider.Repo

  use Hider.Factories.UserFactory
end
