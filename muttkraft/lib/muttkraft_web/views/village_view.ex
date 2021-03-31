defmodule MuttkraftWeb.VillageView do
  use MuttkraftWeb, :view


  require Integer
  def render_field(conn, village: village, row: row, column: column) do
    potential_building = 
    Enum.find(village.buildings, fn(building) ->
      match?(%{row: ^row, column: ^column}, building)
    end)

    case potential_building do
      nil -> link "", to: Routes.village_building_path(conn, :new, village.id, row, column),
                      class: "slot slot-#{row*5+column}"
      building ->
          link "", to: Routes.village_building_path(conn, :new, village.id, row, column),
                       class: "slot building-#{row*5+column} building #{building.type}"
    end
  end

end
