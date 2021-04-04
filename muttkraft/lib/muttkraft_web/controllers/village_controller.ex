defmodule MuttkraftWeb.VillageController do
  use MuttkraftWeb, :controller

  alias Muttkraft.Map
  alias Muttkraft.Map.Village

  def index(conn, _params) do
    villages = Map.list_villages()
    render(conn, "index.html", villages: villages)
  end

  def new(conn, _params) do
    changeset = Map.change_village(%Village{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"village" => village_params}) do
    case Map.create_village(village_params) do
      {:ok, village} ->
        conn
        |> put_flash(:info, "Village created successfully.")
        |> redirect(to: Routes.village_path(conn, :show, village))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    village = Map.get_village_for_rendering!(id)
    Muttkraft.ResourceCalculator.recalculate_village_resources(id)
    resource_pile = village.resource_pile
    render(conn, "show.html", resource_pile: resource_pile, village: village)
  end

  def edit(conn, %{"id" => id}) do
    village = Map.get_village!(id)
    changeset = Map.change_village(village)
    render(conn, "edit.html", village: village, changeset: changeset)
  end

  def update(conn, %{"id" => id, "village" => village_params}) do
    village = Map.get_village!(id)

    case Map.update_village(village, village_params) do
      {:ok, village} ->
        conn
        |> put_flash(:info, "Village updated successfully.")
        |> redirect(to: Routes.village_path(conn, :show, village))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", village: village, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    village = Map.get_village!(id)
    {:ok, _village} = Map.delete_village(village)

    conn
    |> put_flash(:info, "Village deleted successfully.")
    |> redirect(to: Routes.village_path(conn, :index))
  end
end
