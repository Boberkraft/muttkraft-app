defmodule Muttkraft.StructuresTest do
  use Muttkraft.DataCase

  alias Muttkraft.Structures

  describe "building" do
    alias Muttkraft.Structures.Building

    @valid_attrs %{column: 42, row: 42, type: "some type"}
    @update_attrs %{column: 43, row: 43, type: "some updated type"}
    @invalid_attrs %{column: nil, row: nil, type: nil}

    def building_fixture(attrs \\ %{}) do
      {:ok, building} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Structures.create_building()

      building
    end

    test "list_building/0 returns all building" do
      building = building_fixture()
      assert Structures.list_building() == [building]
    end

    test "get_building!/1 returns the building with given id" do
      building = building_fixture()
      assert Structures.get_building!(building.id) == building
    end

    test "create_building/1 with valid data creates a building" do
      assert {:ok, %Building{} = building} = Structures.create_building(@valid_attrs)
      assert building.column == 42
      assert building.row == 42
      assert building.type == "some type"
    end

    test "create_building/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Structures.create_building(@invalid_attrs)
    end

    test "update_building/2 with valid data updates the building" do
      building = building_fixture()
      assert {:ok, %Building{} = building} = Structures.update_building(building, @update_attrs)
      assert building.column == 43
      assert building.row == 43
      assert building.type == "some updated type"
    end

    test "update_building/2 with invalid data returns error changeset" do
      building = building_fixture()
      assert {:error, %Ecto.Changeset{}} = Structures.update_building(building, @invalid_attrs)
      assert building == Structures.get_building!(building.id)
    end

    test "delete_building/1 deletes the building" do
      building = building_fixture()
      assert {:ok, %Building{}} = Structures.delete_building(building)
      assert_raise Ecto.NoResultsError, fn -> Structures.get_building!(building.id) end
    end

    test "change_building/1 returns a building changeset" do
      building = building_fixture()
      assert %Ecto.Changeset{} = Structures.change_building(building)
    end
  end
end
