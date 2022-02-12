defmodule Hider.Factories.Helper do
  def generate_cpf(), do: generate_string_number(11)
  def generate_rg(), do: generate_string_number(10)

  defp generate_string_number(n) do
    1..n
    |> Enum.map(&get_random_number/1)
    |> Enum.join()
  end

  defp get_random_number(_) do
    case :rand.uniform(10) do
      10 -> 0
      n -> n
    end
  end
end
