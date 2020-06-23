# MIT License
#
# Copyright (c) 2020 forte labs inc.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
defmodule Storage.Game do
  @moduledoc ~S"""
  NOTE:
  """
  require Logger
  use Ecto.Schema
  import Ecto.Query

  # ----------------------------------------------------------------------------
  # Public API
  # ----------------------------------------------------------------------------

  @doc """
  Job Posting definition.  This is the record type that will be written/read
  from the database.
  """
  @primary_key false
  schema "games" do
    field(:game_id, :string, primary_key: true)
    field(:name, :string)
    field(:owner, :string)
    field(:pay_id, :string)
    field(:image, :string)
    field(:description, :string)
    field(:active, :boolean)
    field(:meta, :map)
    timestamps(type: :naive_datetime, autogenerate: {Storage.Repo, :timestamps, []})
  end

  # ----------------------------------------------------------------------------
  # Storage.Game.t  Struct definition and accessors and settors
  # ----------------------------------------------------------------------------

  # The basic struct returned from the table.  For now I am just going
  # to use this struct directly however I did add accessors so that
  # it can be used without having to know the actual key names
  # incase I change them in the future
  @type t :: %Storage.Game{
          game_id: String.t(),
          name: String.t(),
          owner: String.t(),
          pay_id: String.t(),
          image: String.t(),
          description: String.t(),
          active: boolean,
          meta: map,
          inserted_at: NativeDateTime.t(),
          updated_at: NativeDateTime.t()
        }

  @doc """
  Create a new record struct for the game
  """
  @spec new(String.t(), String.t(), String.t(), String.t(), String.t(), map) :: Storage.Game.t()
  def new(name, owner, payId, image, description, meta \\ %{}) do
    %Storage.Game{
      game_id: Utils.uuid4(),
      name: name,
      owner: owner,
      pay_id: payId,
      image: image,
      description: description,
      active: true,
      meta: meta
    }
  end

  @doc """
  Storage.Game.t accessor to name
  """
  @spec name(Storage.Game.t()) :: String.t()
  def name(gameT), do: gameT.name

  @doc """
  Storage.Game.t accessor to owner
  """
  @spec owner(Storage.Game.t()) :: String.t()
  def owner(gameT), do: gameT.owner

  @doc """
  Storage.Game.t accessor to pay_id
  """
  @spec pay_id(Storage.Game.t()) :: String.t()
  def pay_id(gameT), do: gameT.pay_id

  @doc """
  Storage.Game.t accessor to image URL
  """
  @spec image(Storage.Game.t()) :: String.t()
  def image(gameT), do: gameT.image

  @doc """
  Storage.Game.t accessor to description
  """
  @spec description(Storage.Game.t()) :: String.t()
  def description(gameT), do: gameT.description

  @doc """
  Storage.Game.t accessor to meta
  """
  @spec meta(Storage.Game.t()) :: String.t()
  def meta(gameT), do: gameT.meta

  # ----------------------------------------------------------------------------
  # Insertion Commands
  # ----------------------------------------------------------------------------

  @doc """
  Write the storage struct to the database.  It is assumed that this is only
  called on the initial creation of the struct and the update APIs are used
  for future changes, etc
  """
  @spec write(Storage.Game.t()) :: {:ok, Storage.Game.t()} | {:error, any()}
  def write(gameT), do: Storage.Repo.insert(gameT)

  # ----------------------------------------------------------------------------
  # Modification Commands
  # ----------------------------------------------------------------------------

  @doc """
  Delete the game record from the database
  """
  def delete(gameId) do
    from(p in Storage.Game, where: p.game_id == ^gameId)
    |> Storage.Repo.delete_all()
  end

  @doc """
  Set if this games name
  """
  @spec setName(String.t(), String.t()) :: {:ok, Storage.Game.t()}
  def setName(gameId, name) do
    Storage.Repo.changeSetField(%{}, :name, name)
    |> writeChanges(gameId)
  end

  @doc """
  Set if this game owner
  """
  @spec setOwner(String.t(), String.t()) :: {:ok, Storage.Game.t()}
  def setOwner(gameId, owner) do
    Storage.Repo.changeSetField(%{}, :owner, owner)
    |> writeChanges(gameId)
  end

  @doc """
  Set if this Game is active or not
  """
  @spec setActiveValue(String.t(), boolean) :: {:ok, Storage.Game.t()}
  def setActiveValue(gameId, active) do
    Storage.Repo.changeSetField(%{}, :active, active)
    |> writeChanges(gameId)
  end

  @doc """
  Set the game image URL
  """
  @spec setImage(String.t(), String.t()) :: {:ok, Storage.Game.t()}
  def setImage(gameId, url) do
    Storage.Repo.changeSetField(%{}, :image, url)
    |> writeChanges(gameId)
  end

  @doc """
  Set the game Description
  """
  @spec setDescription(String.t(), String.t()) :: {:ok, Storage.Game.t()}
  def setDescription(gameId, description) do
    Storage.Repo.changeSetField(%{}, :description, description)
    |> writeChanges(gameId)
  end

  @doc """
  Set the game meta data field
  """
  @spec setMeta(String.t(), map) :: {:ok, Storage.Game.t()}
  def setMeta(gameId, meta) do
    Storage.Repo.changeSetField(%{}, :meta, meta)
    |> writeChanges(gameId)
  end

  # ----------------------------------------------------------------------------
  # Query Operations
  # ----------------------------------------------------------------------------

  @doc """
  Pull all the games from the system.  The cost of this call will grow with the
  total number of games in the system.  It will require a DB read
  """
  @spec queryAll :: [Storage.Game.t()]
  def queryAll() do
    Storage.Repo.get_by(Storage.Game, active: true)
  end

  @doc """
  Pulls a Game recorded based on the given gameId.  This will require a DB operation
  however it will only pull the one record
  """
  @spec query(String.t()) :: nil | Storage.Game.t()
  def query(gameId) do
    Storage.Repo.get_by(Storage.Game, game_id: gameId)
  end

  @doc """
  Reads out a page from the system.  This is showing ALL
  guilds in the system
  """
  @spec queryPage(non_neg_integer, non_neg_integer) ::
          {:ok,
           %{
             count: any,
             first_idx: number,
             last_idx: any,
             last_page: number,
             list: [Storage.Game.t()],
             next: boolean,
             next_page: number,
             page: number,
             prev: boolean
           }}
  def queryPage(page, count) do
    rez =
      Storage.Game
      |> order_by(desc: :id)
      |> Storage.Repo.page(page, count)
      |> parsePage()

    {:ok, rez}
  end

  # ----------------------------------------------------------------------------
  # Private API
  # ----------------------------------------------------------------------------

  defp parsePage(data), do: data

  defp writeChanges(changes, gameId) do
    game = %Storage.Game{game_id: gameId}
    post = Ecto.Changeset.change(game, changes)

    case Storage.Repo.update(post) do
      {:ok, struct} ->
        {:ok, struct}

      {:error, changeset} ->
        Logger.error("[Storage.Game.writeChanges] Failed #{inspect(changeset)}")
        {:error, :update_failed}
    end
  end
end
