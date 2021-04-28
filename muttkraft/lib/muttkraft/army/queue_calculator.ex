defmodule Muttkraft.QueueCalculator do
  def recalate_village_queue(village_id) do

    village = Muttkraft.Map.get_village_for_rendering!(village_id)

    #units_in_queue
  end


  def can_buy?(village, resource_pile, type) do
    created_units_count = Muttkraft.Repo.aggregate(Muttkraft.Army.get_units_in_village(village.id), :count, :id)
    created_units_max = 20
    queued_units_count = Muttkraft.Repo.aggregate(Muttkraft.Army.get_queued_units_in_village(village.id), :count, :id)
    queued_units_max = 7
    errors = []

    errors = if queued_units_count > queued_units_max do
      ["To many units in queue" | errors]
    else
      errors
    end

    # FIXME
    errors =  if created_units_count > created_units_max do 
    errors = ["You cant have more units" | errors]
    else
      errors
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

    resource_pile_computation =
      Enum.reduce(costs, %{pile: resources, changeset: %{}, errors: errors}, fn ({resource_name, resource_cost}, store) ->
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
        |> Map.put(:errors, new_errors)
      end)

    if Enum.empty?(resource_pile_computation.errors) do
      {:ok, resource_pile_computation.changeset}
    else
      {:error, resource_pile_computation.errors}
    end
  end

  def recalculate_queued(village) do
    # set transaction isolation level serializable
    queued_units = Muttkraft.Army.get_queued_units_in_village(village.id)
    ms_to_spend = Time.diff(Time.utc_now(), village.army_last_checked_at) * 1000

    recalulate_units(queued_units, ms_to_spend)
    Muttkraft.update_village(village, %{army_last_checked_at: Time.utc_now()})
  end

  defp recalulate_units(units, ms_to_spend) do
    case units do
      [] -> {}
      [unit | rest_units] ->
        time_left = ms_to_spend - unit_to_queue_time(unit.type) + unit.queue_time
        if time_left > 0 do
          Muttkraft.Army.update_unit(unit, %{queue_time: 0, in_queue: false})
          recalulate_units(rest_units, time_left)
        else
          Muttkraft.Army.update_unit(unit, %{queue_time: time_to_spend})
        end
    end
  end

  defp unit_to_queue_time(type) do
    case type do
      _ -> 10_000
    end
  end
end
