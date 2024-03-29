defmodule Muttkraft.Map.Village do
  use Ecto.Schema
  import Ecto.Changeset

  schema "villages" do
    field :name, :string
    field :last_collected_at, :utc_datetime
    field :army_last_checked_at, :utc_datetime
    belongs_to :user, Accounts.User

    belongs_to :resource_pile, Muttkraft.Resources.Pile
    has_many :buildings, Muttkraft.Structures.Building
    has_many :units, Muttkraft.Army.Unit
    timestamps()
  end

  @doc false
  def changeset(village, attrs) do
    village
    |> cast(attrs, [:name, :last_collected_at, :army_last_checked_at])
    |> validate_required([:name, :last_collected_at, :army_last_checked_at, :resource_pile_id])
    |> cast_assoc(:resource_pile)
  end
end
