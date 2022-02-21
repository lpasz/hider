defmodule Hider.Accounts.Trigram do
  use Ecto.Schema
  import Ecto.Changeset
  alias __MODULE__
  alias Hider.Accounts.User
  alias Hider.Crypt.Argon2

  @required_fields ~w(trigram user_id)a

  schema "trigrams" do
    field :trigram, :binary

    belongs_to :user, User

    timestamps()
  end

  def changeset(trigram \\ %Trigram{}, attrs) do
    trigram
    |> cast(attrs, @required_fields)
  end

  def make_trigrams(val) do
    val
    |> String.codepoints()
    |> make_trigrams_strings()
    |> Enum.map(&Argon2.hash/1)
  end

  defp make_trigrams_strings(third_lst \\ " ", second_lst \\ " ", codepoints, trigrams \\ [])

  defp make_trigrams_strings(third_lst, second_lst, [], trigrams) do
    trigram = third_lst <> second_lst <> " "
    lst_trigram = second_lst <> " " <> " "

    [lst_trigram, trigram | trigrams]
  end

  defp make_trigrams_strings(third_lst, second_lst, [lst | rest], trigrams) do
    new_trigram = third_lst <> second_lst <> lst
    make_trigrams_strings(second_lst, lst, rest, [new_trigram | trigrams])
  end
end
