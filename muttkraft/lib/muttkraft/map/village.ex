defmodule Muttkraft.Map.Village do
  use Ecto.Schema
  import Ecto.Changeset

  schema "villages" do
    field :name, :string
    belongs_to :user, Accounts.User

    belongs_to :resource_pile, Muttkraft.Resources.Pile
    has_many :buildings, Muttkraft.Structures.Building

    timestamps()
  end

  @doc false
  def changeset(village, attrs) do
    village
    |> cast(attrs, [:name, :reso])
    |> validate_required([:name, :resource_pile_id])
    |> cast_assoc(:resource_pile)
  end
end
