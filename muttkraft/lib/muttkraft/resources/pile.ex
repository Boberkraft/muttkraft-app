defmodule Muttkraft.Resources.Pile do
  use Ecto.Schema
  import Ecto.Changeset

  schema "resource_piles" do
    field :blood, :integer, null: false
    field :crystal, :integer, null: false
    field :ore, :integer, null: false
    field :gems, :integer, null: false
    field :gold, :integer, null: false
    field :wood, :integer, null: false

    timestamps()
  end

  @doc false
  def changeset(pile, attrs) do
    pile
    |> cast(attrs, [:gold, :wood, :ore, :crystal, :gems, :blood])
    |> validate_required([:gold, :wood, :ore, :crystal, :gems, :blood])
  end

  def fetch(pile, key) do
    pile
    |> Map.from_struct()
    |> Map.fetch(key)
  end
end
