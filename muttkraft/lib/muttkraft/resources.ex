defmodule Muttkraft.Resources do
  @moduledoc """
  The Resources context.
  """

  import Ecto.Query, warn: false
  alias Muttkraft.Repo

  alias Muttkraft.Resources.Pile

  @doc """
  Returns the list of resource_pile.

  ## Examples

      iex> list_resource_pile()
      [%Pile{}, ...]

  """
  def list_resource_pile do
    Repo.all(Pile)
  end

  @doc """
  Gets a single pile.

  Raises `Ecto.NoResultsError` if the Pile does not exist.

  ## Examples

      iex> get_pile!(123)
      %Pile{}

      iex> get_pile!(456)
      ** (Ecto.NoResultsError)

  """
  def get_pile!(id), do: Repo.get!(Pile, id)

  @doc """
  Creates a pile.

  ## Examples

      iex> create_pile(%{field: value})
      {:ok, %Pile{}}

      iex> create_pile(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def create_empty_pile() do
    %{gold: 0, wood: 0, ore: 0, crystal: 0, gems: 0, blood: 0}
    |> create_pile
  end

  def create_pile(attrs \\ %{}) do
    %Pile{}
    |> Pile.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a pile.

  ## Examples

      iex> update_pile(pile, %{field: new_value})
      {:ok, %Pile{}}

      iex> update_pile(pile, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_pile(%Pile{} = pile, attrs) do
    pile
    |> Pile.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a pile.

  ## Examples

      iex> delete_pile(pile)
      {:ok, %Pile{}}

      iex> delete_pile(pile)
      {:error, %Ecto.Changeset{}}

  """
  def delete_pile(%Pile{} = pile) do
    Repo.delete(pile)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking pile changes.

  ## Examples

      iex> change_pile(pile)
      %Ecto.Changeset{data: %Pile{}}

  """
  def change_pile(%Pile{} = pile, attrs \\ %{}) do
    Pile.changeset(pile, attrs)
  end
end
