defmodule Muttkraft.Map.Village do
  use Ecto.Schema
  import Ecto.Changeset

  schema "villages" do
    field :name, :string
    belongs_to :user, Accounts.User

    has_many :buildings, Muttkraft.Structures.Building

    timestamps()
  end

  @doc false
  def changeset(village, attrs) do
    village
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
