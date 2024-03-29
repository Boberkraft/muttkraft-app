defmodule Muttkraft.Army do
  @moduledoc """
  The Army context.
  """

  import Ecto.Query, warn: false
  alias Muttkraft.Repo

  alias Muttkraft.Army.Unit

  @doc """
  Returns the list of units.

  ## Examples

      iex> list_units()
      [%Unit{}, ...]

  """
  def list_units do
    Repo.all(Unit)
  end

  @doc """
  Gets a single unit.

  Raises `Ecto.NoResultsError` if the Unit does not exist.

  ## Examples

      iex> get_unit!(123)
      %Unit{}

      iex> get_unit!(456)
      ** (Ecto.NoResultsError)

  """
  def get_unit!(id), do: Repo.get!(Unit, id)

  def get_queued_unit!(id) do
    Repo.get_by!(Unit, [in_queue: true, id: id])
  end

  def with_queued_units(query) do
    from q in query, where: q.in_queue == true
  end

  def get_units_in_village(village_id) do
    from u in Unit,
     where: u.village_id == ^village_id
  end

  def get_queued_units_in_village(village_id) do
    Unit
    |> with_queued_units
    |> where([u], u.village_id == ^village_id)
    |> order_by([u], u.inserted_at)
  end


  def get_queued_units_grouped_by_village do
    Unit
    |> group_by([u], [u.id, u.village_id])
    |> order_by([u], u.inserted_at)
    |> where([u], in_queue: true)
    |> Repo.all
  end


  def create_unit_in_queue(attrs \\ %{}) do
    create_unit(Map.put(attrs,  :in_queue, true))
  end
  @doc """
  Creates a unit.

  ## Examples

      iex> create_unit(%{field: value})
      {:ok, %Unit{}}

      iex> create_unit(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_unit(attrs \\ %{}) do
    %Unit{}
    |> Unit.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a unit.

  ## Examples

      iex> update_unit(unit, %{field: new_value})
      {:ok, %Unit{}}

      iex> update_unit(unit, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_unit(%Unit{} = unit, attrs) do
    unit
    |> Unit.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a unit.

  ## Examples

      iex> delete_unit(unit)
      {:ok, %Unit{}}

      iex> delete_unit(unit)
      {:error, %Ecto.Changeset{}}

  """
  def delete_unit(%Unit{} = unit) do
    Repo.delete(unit)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking unit changes.

  ## Examples

      iex> change_unit(unit)
      %Ecto.Changeset{data: %Unit{}}

  """
  def change_unit(%Unit{} = unit, attrs \\ %{}) do
    Unit.changeset(unit, attrs)
  end
end
