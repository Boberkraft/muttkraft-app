defmodule Muttkraft.Map do
  @moduledoc """
  The Map context.
  """

  import Ecto.Query, warn: false
  alias Muttkraft.Repo

  alias Muttkraft.Map.Village

  @doc """
  Returns the list of villages.

  ## Examples

      iex> list_villages()
      [%Village{}, ...]

  """
  def list_villages do
    Repo.all(Village)
  end

  @doc """
  Gets a single village.

  Raises `Ecto.NoResultsError` if the Village does not exist.

  ## Examples

      iex> get_village!(123)
      %Village{}

      iex> get_village!(456)
      ** (Ecto.NoResultsError)

  """
  def get_village!(id), do: Repo.get!(Village, id)


  def get_village_for_rendering!(id) do
    Repo.get(Village |> preload(:buildings) |> preload(:resource_pile), id)
  end
  @doc """
  Creates a village.


  ## Examples

      iex> create_village(%{field: value})
      {:ok, %Village{}}

      iex> create_village(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_village(attrs \\ %{}) do
    empty_pile = Resources.create_empty_pile()

    now = Time.utc_now()
    # TODO: add default values?
    %Village{}
    |> Village.changeset(attrs)
    |> Repo.insert()
    |> Map.put(:resource_pile_id, empty_pile.id)
    |> Map.put(:army_last_checked_at, now)
  end

  @doc """
  Updates a village.

  ## Examples

      iex> update_village(village, %{field: new_value})
      {:ok, %Village{}}

      iex> update_village(village, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_village(%Village{} = village, attrs) do
    village
    |> Village.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a village.

  ## Examples

      iex> delete_village(village)
      {:ok, %Village{}}

      iex> delete_village(village)
      {:error, %Ecto.Changeset{}}

  """
  def delete_village(%Village{} = village) do
    Repo.delete(village)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking village changes.

  ## Examples

      iex> change_village(village)
      %Ecto.Changeset{data: %Village{}}

  """
  def change_village(%Village{} = village, attrs \\ %{}) do
    Village.changeset(village, attrs)
  end
end
