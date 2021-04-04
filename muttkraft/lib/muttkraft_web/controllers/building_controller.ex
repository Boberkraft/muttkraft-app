defmodule MuttkraftWeb.BuildingController do
  use MuttkraftWeb, :controller

  alias Muttkraft.Structures
  alias Muttkraft.Structures.Building

  def index(conn, _params) do
    building = Structures.list_building()
    render(conn, "index.html", building: building)
  end

  def new(conn, %{"village_id" => village_id, "row" => row, "column" => column}) do
    village = Muttkraft.Map.get_village!(village_id)
    changeset = Structures.change_building(%Building{row: row, column: column})
    render(conn, "new.html", village: village, changeset: changeset)
  end

  def create(conn, %{"building" => building_params}) do
    case Structures.create_building(building_params) do
      {:ok, building} ->
        conn
        |> put_flash(:info, "Building created successfully.")
        |> redirect(to: Routes.village_path(conn, :show, building.village_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        village = Muttkraft.Map.get_village!(building_params["village_id"])
        render(conn, "new.html", village: village, changeset: changeset)
    end
  end

  def show(conn, %{"village_id" => village_id, "id" => id}) do
    village = Muttkraft.Map.get_village!(village_id)
    building = Structures.get_building!(id)
    render(conn, "show.html", village: village, building: building)
  end

  def edit(conn, %{"village_id" => village_id, "id" => id}) do
    building = Structures.get_building!(id)
    changeset = Structures.change_building(building)
    render(conn, "edit.html", building: building, changeset: changeset)
  end

  def update(conn, %{"village_id" => village_id, "id" => id, "building" => building_params}) do
    building = Structures.get_building!(id)

    case Structures.update_building(building, building_params) do
      {:ok, building} ->
        conn
        |> put_flash(:info, "Building updated successfully.")
        |> redirect(to: Routes.building_path(conn, :show, building))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", building: building, changeset: changeset)
    end
  end

  def delete(conn, %{"village_id" => village_id, "id" => id}) do
    village = Muttkraft.Map.get_village!(village_id)
    building = Structures.get_building!(id)
    {:ok, _building} = Structures.delete_building(building)

    conn
    |> put_flash(:info, "Building deleted successfully.")
    |> redirect(to: Routes.village_path(conn, :show, village))
  end
end
