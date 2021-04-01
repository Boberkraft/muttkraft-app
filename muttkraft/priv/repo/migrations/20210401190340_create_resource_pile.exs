defmodule Muttkraft.Repo.Migrations.CreateResourcePile do
  use Ecto.Migration

  def change do
    create table(:resource_piles) do
      add :gold, :integer
      add :wood, :integer
      add :ore, :integer
      add :crystal, :integer
      add :gems, :integer
      add :blood, :integer

      timestamps()
    end


    alter table(:villages) do
      add :resource_pile_id, :integer
    end

    # Muttkraft.Map.get_village!(2)
    # |> Muttkraft.Map.update_village(%{resource_pile_id: Muttkraft.Resources.create_empty_pile().id})

    alter table(:villages) do
      modify :resource_pile_id, references(:resource_piles, on_delete: :nothing)
    end

  end
end
