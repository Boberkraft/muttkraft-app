defmodule MuttkraftWeb.UnitController do
  use MuttkraftWeb, :controller

  alias Muttkraft.Army
  alias Muttkraft.Army.Unit

  # def index(conn, _params) do
  #   units = Army.list_units()
  #   render(conn, "index.html", units: units)
  # end

  def new(conn, _params) do
    changeset = Army.change_unit(%Unit{})
    render(conn, "new.html", changeset: changeset)
  end

  def create_in_queue(conn, %{"village_id" => village_id, "building_id" => building_id, "type" => type}) do
    village = Muttkraft.Map.get_village!(village_id)
    # Serializable Isolation Level

    {:ok, results} =
      Muttkraft.Repo.transaction(fn ->
        Muttkraft.Repo.query!("set transaction isolation level serializable")
        resource_pile = Muttkraft.Repo.preload(village, :resource_pile).resource_pile
        case Muttkraft.QueueCalculator.can_buy?(village, resource_pile, type) do
          {:ok, changeset} ->
            {:ok, _pile } = Muttkraft.Resources.update_pile(resource_pile, changeset)
            {:ok, _created_unit}  = Army.create_unit_in_queue(%{type: type, village_id: village_id})
            {:ok}
          {:error, errors} ->
            {:error, errors}
        end
      end)

    case results do
      {:ok} ->
        conn
        |> put_flash(:success, "#{type} created!")
        |> redirect(to: Routes.village_building_path(conn, :show, village_id, building_id))
      {:error, errors} ->
        conn
        |> put_flash(:error, Enum.join(errors, ", "))
        |> redirect(to: Routes.village_building_path(conn, :show, village_id, building_id))
    end
  end

  def delete_from_queue(conn, %{"village_id" => village_id, "building_id" => building_id, "unit_id" => unit_id}) do
    unit = Army.get_queued_unit!(unit_id)

    {:ok, _unit} = Army.delete_unit(unit)

    conn
    |> put_flash(:info, "Queued unit deleted.")
    |> redirect(to: Routes.village_building_path(conn, :show, village_id, building_id))
  end

  def create(conn, %{"unit" => unit_params}) do
    case Army.create_unit(unit_params) do
      {:ok, unit} ->
        conn
        |> put_flash(:info, "Unit created successfully.")
        |> redirect(to: Routes.unit_path(conn, :show, unit))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    unit = Army.get_unit!(id)
    render(conn, "show.html", unit: unit)
  end

  # def edit(conn, %{"id" => id}) do
  #   unit = Army.get_unit!(id)
  #   changeset = Army.change_unit(unit)
  #   render(conn, "edit.html", unit: unit, changeset: changeset)
  # end

  # def update(conn, %{"id" => id, "unit" => unit_params}) do
  #   unit = Army.get_unit!(id)

  #   case Army.update_unit(unit, unit_params) do
  #     {:ok, unit} ->
  #       conn
  #       |> put_flash(:info, "Unit updated successfully.")
  #       |> redirect(to: Routes.unit_path(conn, :show, unit))

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "edit.html", unit: unit, changeset: changeset)
  #   end
  # end

  def delete(conn, %{"id" => id}) do
    unit = Army.get_unit!(id)
    {:ok, _unit} = Army.delete_unit(unit)

    conn
    |> put_flash(:info, "Unit deleted successfully.")
    |> redirect(to: Routes.unit_path(conn, :index))
  end
end
