defmodule Muttkraft.Army.Unit do
  use Ecto.Schema
  import Ecto.Changeset

  schema "units" do
    field :type, :string
    field :in_queue, :boolean
    field :queue_time, :integer
    field :village_id, :id

    timestamps()
  end

  @doc false
  def changeset(unit, attrs) do
    unit
    |> cast(attrs, [:type, :in_queue, :village_id, :queue_time])
    |> validate_required([:type, :in_queue, :village_id])
  end
end

