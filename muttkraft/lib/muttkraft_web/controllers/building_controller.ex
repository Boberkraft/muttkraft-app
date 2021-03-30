defmodule MuttkraftWeb.BuildingController do
  use MuttkraftWeb, :controller

  alias Muttkraft.Structures
  alias Muttkraft.Structures.Building

  def index(conn, _params) do
    building = Structures.list_building()
    render(conn, "index.html", building: building)
  end

  def new(conn, _params) do
    changeset = Structures.change_building(%Building{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"building" => building_params}) do
    case Structures.create_building(building_params) do
      {:ok, building} ->
        conn
        |> put_flash(:info, "Building created successfully.")
        |> redirect(to: Routes.building_path(conn, :show, building))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    building = Structures.get_building!(id)
    render(conn, "show.html", building: building)
  end

  def edit(conn, %{"id" => id}) do
    building = Structures.get_building!(id)
    changeset = Structures.change_building(building)
    render(conn, "edit.html", building: building, changeset: changeset)
  end

  def update(conn, %{"id" => id, "building" => building_params}) do
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

  def delete(conn, %{"id" => id}) do
    building = Structures.get_building!(id)
    {:ok, _building} = Structures.delete_building(building)

    conn
    |> put_flash(:info, "Building deleted successfully.")
    |> redirect(to: Routes.building_path(conn, :index))
  end
end
