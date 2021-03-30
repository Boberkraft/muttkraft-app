defmodule Muttkraft.Repo.Migrations.CreateBuilding do
  use Ecto.Migration

  def change do
    create table(:building) do
      add :type, :string
      add :row, :integer
      add :column, :integer
      add :village_id, references(:villages, on_delete: :nothing)

      timestamps()
    end

    create index(:building, [:village_id])
  end
end
