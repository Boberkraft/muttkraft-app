defmodule Muttkraft.Repo.Migrations.AddLastCollectedAtToVillages do
  use Ecto.Migration

  def change do
    alter table :villages do
      add :last_collected_at, :utc_datetime
    end


#    {:ok, dt} = DateTime.now("Etc/UTC")


#    for village <- Muttkraft.Map.list_villages do
#      Muttkraft.Map.update_village(village, %{last_collected_at: dt})
#    end

#    alter table :villages do
#      modify :last_collected_at, :utc_datetime, null: false
#    end
  end
end
