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
defmodule Storage do
  @moduledoc """
  This module wraps a lot of the internal storage calls.  The goal
  here is to provide an API abstraction layer so we can swap out
  how the storage of these systems work in general
  """

  require Logger

  # ----------------------------------------------------------------------------
  # Types
  # ----------------------------------------------------------------------------
  @type gameT :: %{
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

  @type guildT :: %{
          guild_id: Stringt.t(),
          name: Stringt.t(),
          owner: Stringt.t(),
          pay_id: Stringt.t(),
          image: Stringt.t(),
          description: Stringt.t(),
          members: map(),
          games: map,
          active: boolean,
          meta: map,
          inserted_at: NativeDateTime.t(),
          updated_at: NativeDateTime.t()
        }

  @type page :: %{
          next: boolean,
          prev: boolean,
          last_page: integer,
          next_page: integer,
          page: integer,
          first_idx: integer,
          last_idx: integer,
          count: integer,
          list: [gameT | guildT]
        }

  # ----------------------------------------------------------------------------
  # Public API
  # ----------------------------------------------------------------------------

  # ----------------------------------------------------------------------------
  # Game API
  # ----------------------------------------------------------------------------

  @doc """
  Creates a new game in the storage system.  As part of the map returned the newly
  create game_id also attached to the map
  """
  @spec gameCreate(String.t(), String.t(), String.t(), String.t(), String.t(), String.t(), map) ::
          {:ok, gameT()} | {:error, any}
  def gameCreate(name, owner, payId, image, fee, description, meta \\ %{}) do
    info = Storage.Game.new(name, owner, payId, image, fee, description, meta)

    case Storage.Game.write(info) do
      {:ok, data} ->
        {:ok, gameParse(data)}

      err ->
        err
    end
  end

  @doc """
  Pull out all the active games in the system
  """
  @spec games() :: {:ok, [gameT()]}
  def games() do
    {:ok, Enum.map(Storage.Game.queryAll(), fn e -> gameParse(e) end)}
  end

  @doc """
  Query a specific game
  """
  @spec game(String.t()) :: gameT() | nil
  def game(gameId) do
    Storage.Game.query(gameId)
    |> gameParse()
  end

  @doc """
  Delete a specific game from the db.  Note this does not
  delete other records that store this game id.  This is JUST a storage
  wipe and not a logic wipe of the game data
  """
  @spec gameDelete(String.t()) :: :ok
  def gameDelete(gameId), do: Storage.Game.delete(gameId)

  @doc """
  read out a game page in the standard pagenated format
  """
  @spec gamePage(non_neg_integer(), non_neg_integer()) ::
          {:ok, page()} | {:error, any}
  def gamePage(page, count) do
    case Storage.Game.queryPage(page, count) do
      {:ok, page} ->
        list =
          Enum.map(Map.get(page, :list, []), fn i ->
            gameParse(i)
          end)

        {:ok, Map.put(page, :list, list)}

      err ->
        err
    end
  end

  @doc """
  Hard set the name of the game
  """
  @spec gameSetName(String.t(), String.t()) :: {:ok, gameT()} | {:error, any}
  def gameSetName(gameId, name) do
    case Storage.Game.setName(gameId, name) do
      {:ok, data} -> {:ok, gameParse(data)}
      err -> err
    end
  end

  @doc """
  Hard set the owner of the game
  """
  @spec gameSetOwner(String.t(), String.t()) :: {:ok, gameT()} | {:error, any}
  def gameSetOwner(gameId, owner) do
    case Storage.Game.setOwner(gameId, owner) do
      {:ok, data} -> {:ok, gameParse(data)}
      err -> err
    end
  end

  @doc """
  Activate the game
  """
  @spec gameSetActive(String.t()) :: {:ok, gameT()} | {:error, any}
  def gameSetActive(gameId) do
    case Storage.Game.setActiveValue(gameId, true) do
      {:ok, data} -> {:ok, gameParse(data)}
      err -> err
    end
  end

  @doc """
  Deactivate the game
  """
  @spec gameSetDeactive(String.t()) :: {:ok, gameT()} | {:error, any}
  def gameSetDeactive(gameId) do
    case Storage.Game.setActiveValue(gameId, false) do
      {:ok, data} -> {:ok, gameParse(data)}
      err -> err
    end
  end

  @doc """
  Set the game image URL
  """
  @spec gameSetImage(String.t(), String.t()) :: {:ok, gameT()} | {:error, any}
  def gameSetImage(gameId, url) do
    case Storage.Game.setImage(gameId, url) do
      {:ok, data} -> {:ok, gameParse(data)}
      err -> err
    end
  end

  @doc """
  Set the game fee
  """
  @spec gameSetFee(String.t(), String.t() | float()) :: {:ok, gameT()} | {:error, any}
  def gameSetFee(gameId, fee) when is_float(fee) do
    gameSetFee(gameId, Float.to_string(fee))
  end

  def gameSetFee(gameId, fee) do
    case Storage.Game.setFee(gameId, fee) do
      {:ok, data} -> {:ok, gameParse(data)}
      err -> err
    end
  end

  @doc """
  Set the game description
  """
  @spec gameSetDescription(String.t(), String.t()) :: {:ok, gameT()} | {:error, any}
  def gameSetDescription(gameId, description) do
    case Storage.Game.setDescription(gameId, description) do
      {:ok, data} -> {:ok, gameParse(data)}
      err -> err
    end
  end

  @doc """
  Set the game Meta field
  """
  @spec gameSetMeta(String.t(), map) :: {:ok, gameT()} | {:error, any}
  def gameSetMeta(gameId, meta) do
    case Storage.Game.setMeta(gameId, meta) do
      {:ok, data} -> {:ok, gameParse(data)}
      err -> err
    end
  end

  # ----------------------------------------------------------------------------
  # Guild API
  # ----------------------------------------------------------------------------

  @doc """
  Creates a new game in the storage system.  As part of the map returned the newly
  create guild_id also attached to the map
  """
  @spec guildCreate(String.t(), String.t(), String.t(), String.t(), String.t(), map) ::
          {:ok, gameT()} | {:error, any}
  def guildCreate(name, owner, payId, image, description, meta \\ %{}) do
    info = Storage.Guild.new(name, owner, payId, image, description, meta)

    case Storage.Guild.write(info) do
      {:ok, data} ->
        {:ok, guildParse(data)}

      err ->
        err
    end
  end

  @doc """
  Pull out all the active guilds in the system
  """
  @spec guilds() :: {:ok, [guildT()]}
  def guilds() do
    {:ok, Enum.map(Storage.Guild.queryAll(), fn e -> guildParse(e) end)}
  end

  @doc """
  Query a specific game
  """
  @spec guild(String.t()) :: gameT() | nil
  def guild(guildId) do
    Storage.Guild.query(guildId)
    |> guildParse()
  end

  @doc """
  Delete a specific guild from the db.  Note this does not
  delete other records that store this guild id.  This is JUST a storage
  wipe and not a logic wipe of the guild data
  """
  @spec guildDelete(String.t()) :: :ok
  def guildDelete(gameId), do: Storage.Guild.delete(gameId)

  @doc """
  read out a guild page in the standard pagenated format
  """
  @spec guildPage(non_neg_integer(), non_neg_integer()) ::
          {:ok, page()} | {:error, any}
  def guildPage(page, count) do
    case Storage.Guild.queryPage(page, count) do
      {:ok, page} ->
        list =
          Enum.map(Map.get(page, :list, []), fn i ->
            guildParse(i)
          end)

        {:ok, Map.put(page, :list, list)}

      err ->
        err
    end
  end

  @doc """
  Hard set the members of the Guild.  Members format is like so:

  ```
  %{
    "userId" => integer_ownership_value
  }
  ```
  """
  @spec guildSetMembers(String.t(), map) :: {:ok, guildT()} | {:error, any}
  def guildSetMembers(guildId, members) do
    case Storage.Guild.setMembers(guildId, members) do
      {:ok, data} -> {:ok, guildParse(data)}
      err -> err
    end
  end

  @doc """
  Hard set the name of the Guild
  """
  @spec guildSetName(String.t(), String.t()) :: {:ok, guildT()} | {:error, any}
  def guildSetName(guildId, name) do
    case Storage.Guild.setName(guildId, name) do
      {:ok, data} -> {:ok, guildParse(data)}
      err -> err
    end
  end

  @doc """
  Hard set the owner of the guild
  """
  @spec guildSetOwner(String.t(), String.t()) :: {:ok, guildT()} | {:error, any}
  def guildSetOwner(guildId, owner) do
    case Storage.Guild.setOwner(guildId, owner) do
      {:ok, data} -> {:ok, guildParse(data)}
      err -> err
    end
  end

  @doc """
  Hard set the games of the guild
  """
  @spec guildSetGames(String.t(), map) :: {:ok, guildT()} | {:error, any}
  def guildSetGames(guildId, games) do
    case Storage.Guild.setGames(guildId, games) do
      {:ok, data} -> {:ok, guildParse(data)}
      err -> err
    end
  end

  @doc """
  Activate the guild
  """
  @spec guildSetActive(String.t()) :: {:ok, guildT()} | {:error, any}
  def guildSetActive(guildId) do
    case Storage.Guild.setActiveValue(guildId, true) do
      {:ok, data} -> {:ok, guildParse(data)}
      err -> err
    end
  end

  @doc """
  Deactivate the guild
  """
  @spec guildSetDeactive(String.t()) :: {:ok, guildT()} | {:error, any}
  def guildSetDeactive(gameId) do
    case Storage.Guild.setActiveValue(gameId, false) do
      {:ok, data} -> {:ok, guildParse(data)}
      err -> err
    end
  end

  @doc """
  Set the guild image URL
  """
  @spec guildSetImage(String.t(), String.t()) :: {:ok, guildT()} | {:error, any}
  def guildSetImage(gameId, url) do
    case Storage.Guild.setImage(gameId, url) do
      {:ok, data} -> {:ok, guildParse(data)}
      err -> err
    end
  end

  @doc """
  Set the guild description
  """
  @spec guildSetDescription(String.t(), String.t()) :: {:ok, guildT()} | {:error, any}
  def guildSetDescription(guildId, description) do
    case Storage.Guild.setDescription(guildId, description) do
      {:ok, data} -> {:ok, guildParse(data)}
      err -> err
    end
  end

  @doc """
  Set the guild meta
  """
  @spec guildSetMeta(String.t(), map) :: {:ok, guildT()} | {:error, any}
  def guildSetMeta(guildId, meta) do
    case Storage.Guild.setMeta(guildId, meta) do
      {:ok, data} -> {:ok, guildParse(data)}
      err -> err
    end
  end

  # ----------------------------------------------------------------------------
  # Private APIs
  # ----------------------------------------------------------------------------

  # Convert the internal struct into a generic map
  defp gameParse(data), do: Utils.structToMap(data)
  defp guildParse(data), do: Utils.structToMap(data)
  # defp guildParse(data), do: Utils.structToMap(data)
  # defp orderParse(data), do: Utils.structToMap(data)
  # defp ethParse(data), do: Utils.structToMap(data)
  # defp xrpParse(data), do: Utils.structToMap(data)
  # defp userParse(data), do: Utils.structToMap(data)
end
