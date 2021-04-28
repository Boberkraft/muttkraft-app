defmodule Muttkraft.Repo.Migrations.AddInQueueTimeToUnits do
  use Ecto.Migration

  def change do
    alter table(:units) do
      add :queue_time, :integer, default: 0, null: false
    end
  end
end
