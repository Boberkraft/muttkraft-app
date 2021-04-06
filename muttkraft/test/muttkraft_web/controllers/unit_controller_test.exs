defmodule MuttkraftWeb.UnitControllerTest do
  use MuttkraftWeb.ConnCase

  alias Muttkraft.Army

  @create_attrs %{type: "some type"}
  @update_attrs %{type: "some updated type"}
  @invalid_attrs %{type: nil}

  def fixture(:unit) do
    {:ok, unit} = Army.create_unit(@create_attrs)
    unit
  end

  describe "index" do
    test "lists all units", %{conn: conn} do
      conn = get(conn, Routes.unit_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Units"
    end
  end

  describe "new unit" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.unit_path(conn, :new))
      assert html_response(conn, 200) =~ "New Unit"
    end
  end

  describe "create unit" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.unit_path(conn, :create), unit: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.unit_path(conn, :show, id)

      conn = get(conn, Routes.unit_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Unit"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.unit_path(conn, :create), unit: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Unit"
    end
  end

  describe "edit unit" do
    setup [:create_unit]

    test "renders form for editing chosen unit", %{conn: conn, unit: unit} do
      conn = get(conn, Routes.unit_path(conn, :edit, unit))
      assert html_response(conn, 200) =~ "Edit Unit"
    end
  end

  describe "update unit" do
    setup [:create_unit]

    test "redirects when data is valid", %{conn: conn, unit: unit} do
      conn = put(conn, Routes.unit_path(conn, :update, unit), unit: @update_attrs)
      assert redirected_to(conn) == Routes.unit_path(conn, :show, unit)

      conn = get(conn, Routes.unit_path(conn, :show, unit))
      assert html_response(conn, 200) =~ "some updated type"
    end

    test "renders errors when data is invalid", %{conn: conn, unit: unit} do
      conn = put(conn, Routes.unit_path(conn, :update, unit), unit: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Unit"
    end
  end

  describe "delete unit" do
    setup [:create_unit]

    test "deletes chosen unit", %{conn: conn, unit: unit} do
      conn = delete(conn, Routes.unit_path(conn, :delete, unit))
      assert redirected_to(conn) == Routes.unit_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.unit_path(conn, :show, unit))
      end
    end
  end

  defp create_unit(_) do
    unit = fixture(:unit)
    %{unit: unit}
  end
end
