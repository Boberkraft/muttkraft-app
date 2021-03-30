defmodule Muttkraft.Repo.Migrations.CreateVillages do
  use Ecto.Migration

  def change do
    create table(:villages) do
      add :name, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:villages, [:user_id])
  end
end
