defmodule MuttkraftWeb.VillageControllerTest do
  use MuttkraftWeb.ConnCase

  alias Muttkraft.Map

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:village) do
    {:ok, village} = Map.create_village(@create_attrs)
    village
  end

  describe "index" do
    test "lists all villages", %{conn: conn} do
      conn = get(conn, Routes.village_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Villages"
    end
  end

  describe "new village" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.village_path(conn, :new))
      assert html_response(conn, 200) =~ "New Village"
    end
  end

  describe "create village" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.village_path(conn, :create), village: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.village_path(conn, :show, id)

      conn = get(conn, Routes.village_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Village"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.village_path(conn, :create), village: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Village"
    end
  end

  describe "edit village" do
    setup [:create_village]

    test "renders form for editing chosen village", %{conn: conn, village: village} do
      conn = get(conn, Routes.village_path(conn, :edit, village))
      assert html_response(conn, 200) =~ "Edit Village"
    end
  end

  describe "update village" do
    setup [:create_village]

    test "redirects when data is valid", %{conn: conn, village: village} do
      conn = put(conn, Routes.village_path(conn, :update, village), village: @update_attrs)
      assert redirected_to(conn) == Routes.village_path(conn, :show, village)

      conn = get(conn, Routes.village_path(conn, :show, village))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, village: village} do
      conn = put(conn, Routes.village_path(conn, :update, village), village: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Village"
    end
  end

  describe "delete village" do
    setup [:create_village]

    test "deletes chosen village", %{conn: conn, village: village} do
      conn = delete(conn, Routes.village_path(conn, :delete, village))
      assert redirected_to(conn) == Routes.village_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.village_path(conn, :show, village))
      end
    end
  end

  defp create_village(_) do
    village = fixture(:village)
    %{village: village}
  end
end
