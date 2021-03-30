defmodule Muttkraft.Structures.Building do
  use Ecto.Schema
  import Ecto.Changeset

  schema "building" do
    field :column, :integer
    field :row, :integer
    field :type, Ecto.Enum, values: [:town_hall, :sawmill]
    field :village_id, :id

    timestamps()
  end

  @doc false
  def changeset(building, attrs) do
    building
    |> cast(attrs, [:type, :row, :column])
    |> validate_required([:type, :row, :column])
  end
end
