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
defmodule Storage.Guild do
  @moduledoc ~S"""
  Guild Storage Management.
  """
  require Logger
  use Ecto.Schema
  import Ecto.Query

  # ----------------------------------------------------------------------------
  # Public API
  # ----------------------------------------------------------------------------

  @doc """
  Guild Data definition.  This is the record type that will be written/read
  from the database.
  """
  @primary_key false
  schema "guilds" do
    field(:guild_id, :string, primary_key: true)
    field(:name, :string)
    field(:owner, :string)
    field(:pay_id, :string)
    field(:image, :string)
    field(:description, :string)
    field(:members, :map)
    field(:games, :map)
    field(:active, :boolean)
    field(:meta, :map)
    timestamps(type: :naive_datetime, autogenerate: {Storage.Repo, :timestamps, []})
  end

  # ----------------------------------------------------------------------------
  # Storage.Guild.t  Struct definition and accessors and settors
  # ----------------------------------------------------------------------------

  # The basic struct returned from the table.  For now I am just going
  # to use this struct directly however I did add accessors so that
  # it can be used without having to know the actual key names
  # incase I change them in the future
  @type t :: %Storage.Guild{
          guild_id: Stringt.t(),
          name: Stringt.t(),
          owner: Stringt.t(),
          pay_id: Stringt.t(),
          image: Stringt.t(),
          description: Stringt.t(),
          members: map(),
          games: map(),
          active: boolean,
          meta: map,
          inserted_at: NativeDateTime.t(),
          updated_at: NativeDateTime.t()
        }

  @doc """
  Create a new record struct for the game
  """
  @spec new(String.t(), String.t(), String.t(), String.t(), String.t(), map) :: Storage.Guild.t()
  def new(name, owner, payId, image, description, meta \\ %{}) do
    %Storage.Guild{
      guild_id: Utils.uuid4(),
      name: name,
      owner: owner,
      pay_id: payId,
      image: image,
      description: description,
      members: %{owner => 100},
      games: %{},
      active: true,
      meta: meta
    }
  end

  # ----------------------------------------------------------------------------
  # Insertion Commands
  # ----------------------------------------------------------------------------

  @doc """
  Write the storage struct to the database.  It is assumed that this is only
  called on the initial creation of the struct and the update APIs are used
  for future changes, etc
  """
  @spec write(Storage.Guild.t()) :: {:ok, Storage.Guild.t()} | {:error, any()}
  def write(guildT), do: Storage.Repo.insert(guildT)

  # ----------------------------------------------------------------------------
  # Modification Commands
  # ----------------------------------------------------------------------------

  @doc """
  Delete the game record from the database
  """
  def delete(guildId) do
    from(p in Storage.Guild, where: p.guild_id == ^guildId)
    |> Storage.Repo.delete_all()
  end

  @doc """
  Update the guild members list.  Since this is an array and I am trying to
  avoid custom SQL at this moment it is currently a requirement that all
  member lists be managed outside of the DB

  Note:  members should be a map like so:
  %{"user_id_2": integer_ownership_value,
    "user_id_2" integer_ownership_value}
  """
  @spec setGames(String.t(), map) :: {:ok, Storage.Guild.t()}
  def setMembers(guildId, members) do
    Storage.Repo.changeSetField(%{}, :members, members)
    |> writeChanges(guildId)
  end

  @doc """
  Set the owner of the guild.  Only owners can change guild properties
  """
  @spec setName(String.t(), String.t()) :: {:ok, Storage.Guild.t()}
  def setName(guildId, name) do
    Storage.Repo.changeSetField(%{}, :name, name)
    |> writeChanges(guildId)
  end

  @doc """
  Set the owner of the guild.  Only owners can change guild properties
  """
  @spec setGames(String.t(), String.t()) :: {:ok, Storage.Guild.t()}
  def setOwner(guildId, owner) do
    Storage.Repo.changeSetField(%{}, :owner, owner)
    |> writeChanges(guildId)
  end

  @doc """
  Update the games this guild is active for.  Since this is an array and I am trying to
  avoid custom SQL at this moment it is currently a requirement that all
  member lists be managed outside of the DB

  Note:
  {
    "game_id_1" => true/false,
    "game_id_2" => true/false
  }
  """
  @spec setGames(String.t(), map) :: {:ok, Storage.Guild.t()}
  def setGames(guildId, games) do
    Storage.Repo.changeSetField(%{}, :games, games)
    |> writeChanges(guildId)
  end

  @doc """
  Set if this guild is active or not
  """
  @spec setActiveValue(String.t(), boolean) :: {:ok, Storage.Guild.t()}
  def setActiveValue(guildId, active) do
    Storage.Repo.changeSetField(%{}, :active, active)
    |> writeChanges(guildId)
  end

  @doc """
  Set the guild image URL
  """
  @spec setImage(String.t(), String.t()) :: {:ok, Storage.Guild.t()}
  def setImage(guildId, url) do
    Storage.Repo.changeSetField(%{}, :image, url)
    |> writeChanges(guildId)
  end

  @doc """
  Set the guild Description
  """
  @spec setDescription(String.t(), String.t()) :: {:ok, Storage.Guild.t()}
  def setDescription(guildId, description) do
    Storage.Repo.changeSetField(%{}, :description, description)
    |> writeChanges(guildId)
  end

  @doc """
  Set the guild Meta
  """
  @spec setMeta(String.t(), map) :: {:ok, Storage.Guild.t()}
  def setMeta(guildId, meta) do
    Storage.Repo.changeSetField(%{}, :meta, meta)
    |> writeChanges(guildId)
  end

  ## ----------------------------------------------------------------------------
  ## Query Operations
  ## ----------------------------------------------------------------------------

  @doc """
  Pull all the guilds from the system.  The cost of this call will grow with the
  total number of guilds in the system.  It will require a DB read
  """
  @spec queryAll :: [Storage.Guild.t()]
  def queryAll() do
    Storage.Repo.all(Storage.Guild)
  end

  @doc """
  Pulls a Guild recorded based on the given guildId.  This will require a DB operation
  however it will only pull the one record
  """
  @spec query(String.t()) :: nil | Storage.Guild.t()
  def query(guildId) do
    Storage.Repo.get_by(Storage.Guild, guild_id: guildId)
  end

  @doc """
  Pulls a Guild recordeds based on the given user_id.  This will require a DB operation
  however it will only pull the one record.

  NOTE: This command currently sucks and needs to be optimized to use the database
        to handle the filtering part
  """
  @spec queryUser(String.t()) :: nil | [Storage.Guild.t()]
  def queryUser(userId) do
    Enum.filter(queryAll(), fn x ->
      Map.has_key?(x.members, userId)
    end)
  end

  @doc """
  Pulls a Guild recordeds based on the given game_id.  This will require a DB operation
  however it will only pull the one record.

  NOTE: This command currently sucks and needs to be optimized to use the database
        to handle the filtering part
  """
  @spec queryGame(String.t()) :: nil | [Storage.Guild.t()]
  def queryGame(gameId) do
    Enum.filter(queryAll(), fn x ->
      Map.has_key?(x.games, gameId)
    end)
  end

  @doc """
  Get all the guild names
  """
  @spec queryNames([String.t()]) :: {:ok, map} | {:error, any}
  def queryNames(guildIds) do
    query =
      from(g in "guilds",
        where: g.guild_id in ^guildIds,
        select: {g.guild_id, g.name}
      )

    case Storage.Repo.all(query) do
      nil ->
        {:ok, %{}}

      data ->
        rez =
          Enum.reduce(data, %{}, fn {id, name}, acc ->
            Map.put(acc, id, name)
          end)

        {:ok, rez}
    end
  end

  @doc """
  Reads out a page from the system.
  """
  @spec queryPage(non_neg_integer, non_neg_integer) ::
          {:ok,
           %{
             count: any,
             first_idx: number,
             last_idx: any,
             last_page: number,
             list: [Storage.Guild.t()],
             next: boolean,
             next_page: number,
             page: number,
             prev: boolean
           }}
  def queryPage(page, count) do
    rez =
      Storage.Guild
      |> order_by(desc: :id)
      |> Storage.Repo.page(page, count)
      |> parsePage()

    {:ok, rez}
  end

  # ----------------------------------------------------------------------------
  # Private API
  # ----------------------------------------------------------------------------

  defp parsePage(data), do: data

  defp writeChanges(changes, guildId) do
    guild = %Storage.Guild{guild_id: guildId}
    post = Ecto.Changeset.change(guild, changes)

    case Storage.Repo.update(post) do
      {:ok, struct} ->
        {:ok, struct}

      {:error, changeset} ->
        Logger.error("[Storage.Guild.writeChanges] Failed #{inspect(changeset)}")
        {:error, :update_failed}
    end
  end
end
