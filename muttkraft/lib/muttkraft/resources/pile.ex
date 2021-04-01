defmodule Muttkraft.Resources.Pile do
  use Ecto.Schema
  import Ecto.Changeset

  schema "resource_piles" do
    field :blood, :integer
    field :crystal, :integer
    field :ore, :integer
    field :gems, :integer
    field :gold, :integer
    field :wood, :integer

    timestamps()
  end

  @doc false
  def changeset(pile, attrs) do
    pile
    |> cast(attrs, [:gold, :wood, :ore, :crystal, :gems, :blood])
    |> validate_required([:gold, :wood, :ore, :crystal, :gems, :blood])
  end
end
