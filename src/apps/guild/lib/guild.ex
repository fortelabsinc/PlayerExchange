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
defmodule Guild do
  @moduledoc """
  Main interface module for the Guild system.  NOTE:  this for now will just
  do much of the logic for the commands.  Later we can move this API into
  something a bit more encapulated, etc
  """

  require Logger

  # ----------------------------------------------------------------------------
  # Public API
  # ----------------------------------------------------------------------------

  @doc """
  Create a new guild in the system
  """
  @spec create(String.t(), String.t(), String.t(), String.t(), map) ::
          {:ok, Storage.gameT()} | {:error, :not_found}
  def create(name, owner, image, description, meta \\ %{}) do
    # Let's create the game wallets
    case Blockchain.createAccount(name) do
      {:ok, payId} ->
        # Let's create the record entry in the database
        # for this guy
        Storage.guildCreate(name, owner, payId, image, description, meta)

      err ->
        err
    end
  end

  @doc """
  Read all the guilds from the system
  """
  @spec all() :: {:ok, [Storage.guildT()]}
  def all(), do: Storage.guilds()

  @doc """
  Read a page of guilds from the system
  """
  @spec page(non_neg_integer(), non_neg_integer()) ::
          {:ok, Storage.page()} | {:error, any}
  def page(page, count), do: Storage.guildPage(page, count)

  @doc """
  Look up a specific guild info

  NOTE:  This will only succeed if the owner field matchs the userId
  """
  @spec info(String.t()) ::
          {:ok, Storage.guildT()} | {:error, :not_found}
  def info(guildId) do
    case Storage.guild(guildId) do
      nil -> {:error, :not_found}
      data -> {:ok, data}
    end
  end

  @doc """
  Look up a bunch of guild names based on the passed in IDs
  """
  @spec names([String.t()]) ::
          {:ok, %{String.t() => String.t()}} | {:error, :not_found}
  def names(ids), do: Storage.gameNames(ids)

  @doc """
  Update the name field for the game

  NOTE:  This will only succeed if the owner field matchs the userId
  """
  @spec updateName(String.t(), String.t(), String.t()) ::
          {:ok, Storage.guildT()} | {:error, atom}
  def updateName(guildId, userId, name) do
    case Storage.guild(guildId) do
      nil ->
        {:error, :not_found}

      data ->
        if data.owner == userId do
          Storage.guildSetName(guildId, name)
        else
          {:error, :not_owner}
        end
    end
  end

  @doc """
  Update the Guild owner field

  NOTE:  This will only succeed if the owner field matchs the userId
  """
  @spec updateOwner(String.t(), String.t(), String.t()) ::
          {:ok, Storage.guildT()} | {:error, atom}
  def updateOwner(guildId, userId, owner) do
    case Storage.guild(guildId) do
      nil ->
        {:error, :not_found}

      data ->
        if data.owner == owner do
          # now lets verify that the new owner is also a member
          if Map.has_key?(data.members, userId) do
            Storage.guildSetOwner(guildId, owner)
          else
            {:error, :not_member}
          end
        else
          {:error, :not_owner}
        end
    end
  end

  @doc """
  Update the guild image field

  NOTE:  This will only succeed if the owner field matchs the userId
  """
  @spec updateImage(String.t(), String.t(), String.t()) ::
          {:ok, Storage.guildT()} | {:error, atom}
  def updateImage(guildId, userId, image) do
    case Storage.guild(guildId) do
      nil ->
        {:error, :not_found}

      data ->
        if data.owner == userId do
          Storage.guildSetImage(guildId, image)
        else
          {:error, :not_owner}
        end
    end
  end

  @doc """
  Update the guild description field

  NOTE:  This will only succeed if the owner field matchs the userId
  """
  @spec updateDescription(String.t(), String.t(), String.t()) ::
          {:ok, Storage.guildT()} | {:error, atom}
  def updateDescription(guildId, userId, description) do
    case Storage.guild(guildId) do
      nil ->
        {:error, :not_found}

      data ->
        if data.owner == userId do
          Storage.guildSetDescription(guildId, description)
        else
          {:error, :not_owner}
        end
    end
  end

  @doc """
  Update the guild meta field

  NOTE:  This will only succeed if the owner field matchs the userId
  """
  @spec updateMeta(String.t(), String.t(), String.t()) ::
          {:ok, Storage.guildT()} | {:error, atom}
  def updateMeta(guildId, userId, meta) do
    case Storage.guild(guildId) do
      nil ->
        {:error, :not_found}

      data ->
        if data.owner == userId do
          Storage.guildSetMeta(guildId, meta)
        else
          {:error, :not_owner}
        end
    end
  end

  @doc """
  """
  @spec addUser(String.t(), String.t(), String.t()) ::
          {:ok, Storage.guildT()} | {:error, atom}
  def addUser(guildId, ownerId, userId) do
    case Storage.guild(guildId) do
      nil ->
        {:error, :not_found}

      data ->
        if data.owner == ownerId do
          members = data.members

          if Map.has_key?(members, userId) do
            {:error, :already_member}
          else
            Storage.guildSetMembers(guildId, Map.put(members, userId, 10))
          end
        else
          {:error, :not_owner}
        end
    end
  end

  @doc """
  """
  @spec removeUser(String.t(), String.t(), String.t()) ::
          {:ok, Storage.guildT()} | {:error, atom}
  def removeUser(guildId, ownerId, userId) do
    case Storage.guild(guildId) do
      nil ->
        {:error, :not_found}

      data ->
        if data.owner == ownerId do
          members = data.members

          if Map.has_key?(members, userId) do
            Storage.guildSetMembers(guildId, Map.delete(members, userId))
          else
            {:error, :not_member}
          end
        else
          {:error, :not_owner}
        end
    end
  end

  @doc """
  """
  @spec updateUserStake(String.t(), String.t(), String.t(), integer) ::
          {:ok, Storage.guildT()} | {:error, atom}
  def updateUserStake(guildId, ownerId, userId, stake) do
    case Storage.guild(guildId) do
      nil ->
        {:error, :not_found}

      data ->
        if data.owner == ownerId do
          members = data.members

          case Map.get(members, userId, nil) do
            nil ->
              {:error, :not_member}

            _ ->
              Storage.guildSetMembers(guildId, Map.put(members, userId, stake))
          end
        else
          {:error, :not_owner}
        end
    end
  end

  @doc """
  """
  @spec addGame(String.t(), String.t(), String.t()) ::
          {:ok, Storage.guildT()} | {:error, atom}
  def addGame(guildId, ownerId, gameId) do
    case Storage.guild(guildId) do
      nil ->
        {:error, :not_found}

      data ->
        if data.owner == ownerId do
          games = data.games

          if Map.has_key?(games, gameId) do
            {:error, :already_member}
          else
            games = Map.put(games, gameId, true)
            Storage.guildSetGames(guildId, games)
          end
        else
          {:error, :not_owner}
        end
    end
  end

  @doc """
  """
  @spec removeGame(String.t(), String.t(), String.t()) ::
          {:ok, Storage.guildT()} | {:error, atom}
  def removeGame(guildId, ownerId, gameId) do
    case Storage.guild(guildId) do
      nil ->
        {:error, :not_found}

      data ->
        if data.owner == ownerId do
          games = data.games

          if Map.has_key?(games, gameId) do
            games = Map.delete(games, gameId)
            Storage.guildSetGames(guildId, games)
          else
            {:error, :not_member}
          end
        else
          {:error, :not_owner}
        end
    end
  end

  @doc """
  Delete the game from the system

  NOTE:  This will only succeed if the owner field matchs the userId
  """
  @spec delete(String.t(), String.t()) ::
          :ok | {:error, atom}
  def delete(guildId, userId) do
    case Storage.guild(guildId) do
      nil ->
        {:error, :not_found}

      data ->
        if data.owner == userId do
          Storage.guildDelete(guildId)
        else
          {:error, :not_owner}
        end
    end
  end

  @doc """
  """
  @spec balance(String.t(), String.t()) ::
          {:ok, [map]} | {:error, any}
  def balance(guildId, userId) do
    case Storage.guild(guildId) do
      nil ->
        {:error, :not_found}

      data ->
        if data.owner == userId do
          # now lets verify that the new owner is also a member
          Blockchain.walletBalances(data.pay_id)
        else
          {:error, :not_owner}
        end
    end
  end
end
