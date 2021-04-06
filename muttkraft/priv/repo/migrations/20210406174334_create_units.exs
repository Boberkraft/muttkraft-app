defmodule Muttkraft.Repo.Migrations.CreateUnits do
  use Ecto.Migration

  def change do
    create table(:units) do
      add :type, :string, null: false
      add :in_queue, :boolean, null: false
      add :village_id, references(:villages, on_delete: :nothing)

      timestamps()
    end

    create index(:units, [:village_id])
  end
end
