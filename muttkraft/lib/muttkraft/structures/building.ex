defmodule Muttkraft.Structures.Building do
  use Ecto.Schema
  import Ecto.Changeset

  schema "building" do
    field :column, :integer
    field :row, :integer
    field :type, Ecto.Enum, values: Enum.map(MuttkraftWeb.BuildingView.list_building_types, &(String.to_atom(&1)))

    belongs_to :village, Muttkraft.Village
    timestamps()
  end

  @doc false
  def changeset(building, attrs) do
    building
    |> cast(attrs, [:type, :row, :column, :village_id])
    |> validate_required([:type, :row, :column, :village_id])
    |> cast_assoc(:village)
  end
end
