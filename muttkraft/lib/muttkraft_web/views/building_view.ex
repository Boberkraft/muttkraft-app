defmodule MuttkraftWeb.BuildingView do
  use MuttkraftWeb, :view

  def list_building_types do
    ["town_hall", "sawmill", "shooting_range", "ore_pit", "gold_mine"]
  end

  def building_image_file(building_type) do
    file_name =
    case building_type do
      "town_hall" -> "town_hall.png"
      "sawmill" -> "sawmill.gif"
      "shooting_range" -> "shooting_range.png"
      "ore_pit" -> "ore_pit.gif"
      "gold_mine" -> "gold_mine.gif"
    end

    "/images/#{file_name}"
  end
end
