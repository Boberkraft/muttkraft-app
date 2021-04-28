defmodule Muttkraft.Repo.Migrations.AddInQueueTimeToUnits do
  use Ecto.Migration

  def change do
    alter table(:villages) do
      add :army_last_checked_at, :utc_datetime
    end
  end
end
