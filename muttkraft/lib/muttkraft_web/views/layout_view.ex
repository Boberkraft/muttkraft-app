defmodule MuttkraftWeb.LayoutView do
  use MuttkraftWeb, :view


  def buildings_css(conn) do
    for type <- MuttkraftWeb.BuildingView.list_building_types do
      ~s"""
      
      """
    end |> Enum.join("\n")
  end
end
