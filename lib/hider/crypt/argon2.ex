defmodule Hider.Crypt.Argon2 do
  @salt :hider |> Application.compile_env!([:argon2, :salt]) |> Base.decode64!()

  def hash(text) do
    text
    |> Argon2.Base.hash_password(@salt)
    |> String.split("$")
    |> List.pop_at(-1)
    |> then(fn {hash, _} -> hash end)
  end
end
