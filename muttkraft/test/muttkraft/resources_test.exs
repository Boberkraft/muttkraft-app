defmodule Muttkraft.ResourcesTest do
  use Muttkraft.DataCase

  alias Muttkraft.Resources

  describe "resource_pile" do
    alias Muttkraft.Resources.Pile

    @valid_attrs %{blood: 42, crystal: 42, gems: 42, gold: 42, wood: 42}
    @update_attrs %{blood: 43, crystal: 43, gems: 43, gold: 43, wood: 43}
    @invalid_attrs %{blood: nil, crystal: nil, gems: nil, gold: nil, wood: nil}

    def pile_fixture(attrs \\ %{}) do
      {:ok, pile} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Resources.create_pile()

      pile
    end

    test "list_resource_pile/0 returns all resource_pile" do
      pile = pile_fixture()
      assert Resources.list_resource_pile() == [pile]
    end

    test "get_pile!/1 returns the pile with given id" do
      pile = pile_fixture()
      assert Resources.get_pile!(pile.id) == pile
    end

    test "create_pile/1 with valid data creates a pile" do
      assert {:ok, %Pile{} = pile} = Resources.create_pile(@valid_attrs)
      assert pile.blood == 42
      assert pile.crystal == 42
      assert pile.gems == 42
      assert pile.gold == 42
      assert pile.wood == 42
    end

    test "create_pile/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Resources.create_pile(@invalid_attrs)
    end

    test "update_pile/2 with valid data updates the pile" do
      pile = pile_fixture()
      assert {:ok, %Pile{} = pile} = Resources.update_pile(pile, @update_attrs)
      assert pile.blood == 43
      assert pile.crystal == 43
      assert pile.gems == 43
      assert pile.gold == 43
      assert pile.wood == 43
    end

    test "update_pile/2 with invalid data returns error changeset" do
      pile = pile_fixture()
      assert {:error, %Ecto.Changeset{}} = Resources.update_pile(pile, @invalid_attrs)
      assert pile == Resources.get_pile!(pile.id)
    end

    test "delete_pile/1 deletes the pile" do
      pile = pile_fixture()
      assert {:ok, %Pile{}} = Resources.delete_pile(pile)
      assert_raise Ecto.NoResultsError, fn -> Resources.get_pile!(pile.id) end
    end

    test "change_pile/1 returns a pile changeset" do
      pile = pile_fixture()
      assert %Ecto.Changeset{} = Resources.change_pile(pile)
    end
  end
end
