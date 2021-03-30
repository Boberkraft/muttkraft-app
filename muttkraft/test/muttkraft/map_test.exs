defmodule Muttkraft.MapTest do
  use Muttkraft.DataCase

  alias Muttkraft.Map

  describe "villages" do
    alias Muttkraft.Map.Village

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def village_fixture(attrs \\ %{}) do
      {:ok, village} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Map.create_village()

      village
    end

    test "list_villages/0 returns all villages" do
      village = village_fixture()
      assert Map.list_villages() == [village]
    end

    test "get_village!/1 returns the village with given id" do
      village = village_fixture()
      assert Map.get_village!(village.id) == village
    end

    test "create_village/1 with valid data creates a village" do
      assert {:ok, %Village{} = village} = Map.create_village(@valid_attrs)
      assert village.name == "some name"
    end

    test "create_village/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Map.create_village(@invalid_attrs)
    end

    test "update_village/2 with valid data updates the village" do
      village = village_fixture()
      assert {:ok, %Village{} = village} = Map.update_village(village, @update_attrs)
      assert village.name == "some updated name"
    end

    test "update_village/2 with invalid data returns error changeset" do
      village = village_fixture()
      assert {:error, %Ecto.Changeset{}} = Map.update_village(village, @invalid_attrs)
      assert village == Map.get_village!(village.id)
    end

    test "delete_village/1 deletes the village" do
      village = village_fixture()
      assert {:ok, %Village{}} = Map.delete_village(village)
      assert_raise Ecto.NoResultsError, fn -> Map.get_village!(village.id) end
    end

    test "change_village/1 returns a village changeset" do
      village = village_fixture()
      assert %Ecto.Changeset{} = Map.change_village(village)
    end
  end
end
