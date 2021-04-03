defmodule MuttkraftWeb.ResourceView do
  use MuttkraftWeb, :view

  def list_resources do
    [:gold, :wood, :ore, :blood, :gems, :crystal]
  end

  def get_resource(name, resource_pile) do
    Map.get(resource_pile, name)
  end

  def resource_image_filename(resource) do
    case resource do
      :gold -> "gold.gif"
      :wood -> "wood.png"
      :ore -> "ore.png"
      :blood -> "blood.gif"
      :gems -> "gems.gif"
      :crystal -> "crystal.gif"
    end
  end
end
