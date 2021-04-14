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

  def create_in_queue(conn, %{"village_id" => village_id, "type" => type}) do
    village = Muttkraft.Map.get_village!(village_id)
    # Serializable Isolation Level

    Muttkraft.Repo.transaction(fn ->
      Muttkraft.Repo.query!("set transaction isolation level serializable")

      queued_units_count = Muttkraft.Repo.aggregate(Muttkraft.Army.get_queued_units_in_village(village_id), :count, :id)
      if queued_units_count > 7 do
        conn
        |> put_flash(:info, "To many units in queue")
        |> redirect(to: Routes.village_path(conn, :show, village_id))
      end

      created_units_count = Muttkraft.Repo.aggregate(Muttkraft.Army.get_units_in_village(village_id), :count, :id)
      if created_units_count > 20 do
        conn
        |> put_flash(:info, "You cant have more units")
        |> redirect(to: Routes.village_path(conn, :show, village_id))
      end

      resources = Muttkraft.Repo.preload(village, :resource_pile).resource_pile

      costs = case type do
                "goblin" -> %{gold: 50, wood: 100}
                "orc" -> %{gold: 300, wood: 400}
                "ogre" -> %{gold: 400, ore: 400}
                "peasant" -> %{gold: 50, wood: 100}
                "pikerman" -> %{gold: 150, wood: 200}
                "halfling" -> %{wood: 50, ore: 100}
                "boar" -> %{wood: 300, ore: 300}
                "hydra" -> %{gold: 1000, blood: 300}
              end

      resource_pile_computation = Enum.reduce(costs, %{pile: resources, changeset: %{}, errors: []}, fn ({resource_name, resource_cost}, store) ->
        current = store.pile[resource_name]
        new = current - resource_cost

        new_errors = cond do
          new < 0 -> ["Not enought #{resource_name}" | store[:errors]]
          new > 1000 -> ["To much resources?" | store[:errors]]
          true -> store[:errors]
        end

        new_changeset = Map.put(store[:changeset], resource_name, new)

        store
        |> Map.put(:changeset, new_changeset)
        |> Map.put(:new_errors, new_errors)
      end)


      if length(resource_pile_computation.errors) > 0 do
        conn
        |> put_flash(:info, "You dont have enough resources!")
        |> redirect(to: Routes.village_path(conn, :show, village_id))
      end

      {:ok, _pile } = Muttkraft.Resources.update_pile(resources, resource_pile_computation[:changeset])
      {:ok, created_unit}  = Army.create_unit_in_queue(%{type: type, village_id: village_id})

     
    end)

    conn
    |> put_flash(:info, "created!")
    |> redirect(to: Routes.village_path(conn, :show, village_id))
  end

  def delete_from_queue(conn, %{"village_id" => village_id, "id" => id}) do
    unit = Army.get_queued_unit!(id)

    {:ok, _unit} = Army.delete_unit(unit)

    conn
    |> put_flash(:info, "Queued unit deleted.")
    |> redirect(to: Routes.village_path(conn, :show, village_id))
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
