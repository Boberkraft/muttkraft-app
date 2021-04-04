defmodule Muttkraft.ResourceCalculator do
  def recalculate_village_resources(village_id) do
    # Muttkraft.Repo.query("SELECT pg_advisory_xact_lock(village-resource-pit-#{village_id})")

    village = Muttkraft.Map.get_village_for_rendering!(village_id)

    last_collected_at = village.last_collected_at
    {:ok, now} = DateTime.now("Etc/UTC")

    diff = DateTime.diff(now, last_collected_at)

    recalculate_buildings(village, diff)

    Muttkraft.Map.update_village(village, %{last_collected_at: now})
  end

  
  def recalculate_buildings(village, seconds) do
    new_resources =
      village.buildings
      |> Enum.map(&(gain_from_building(&1, village, seconds)))
      |> Enum.reject(&is_nil/1)
      |> Enum.reduce(%{}, fn {what, value}, pile ->
      Map.put(pile, what, add_value(what, value, village))
      
    end)

      Muttkraft.Resources.update_pile(village.resource_pile, new_resources)
  end

  # TODO: dodac last_collected_at do buildingu :)
  def gain_from_building(building, _village, seconds) do
    case building.type do
      :gold_mine -> {:gold, seconds}
      :sawmill -> {:wood, seconds * 2}
      :ore_pit -> {:ore, seconds * 1}
      _ -> nil
    end
  end

  def add_value(resource_name, value, village) do
    val = village.resource_pile[resource_name] + value
    max(0, min(val, 1000))
  end
end
