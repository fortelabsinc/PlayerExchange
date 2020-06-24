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
defmodule Gateway.Router.Portal.Commands.Handler.Guild do
  @moduledoc """
  Business logic processor for the request.  This module knows how to process
  and/or hand off the actual processing of the request
  """
  require Logger

  # ----------------------------------------------------------------------------
  # Public API
  # ----------------------------------------------------------------------------

  @doc """
  A basic init function for anything we want to make sure is setup before we
  start handling incoming requests
  """
  @spec init :: :ok
  def init() do
    :ok
  end

  @doc """
  A simple ping message
  """
  @spec ping :: <<_::32>>
  def ping(), do: "pong"

  @doc """
  Create a new Game in the system
  """
  @spec create(String.t(), String.t(), String.t(), String.t()) ::
          {:ok, Storage.guildT()} | {:error, any}
  def create(name, owner, image, description) do
    Guild.create(name, owner, image, description)
  end

  @doc """
  Get the app info from the billing data
  """
  @spec info(String.t()) :: {:ok, Storage.guildT()} | {:error, :not_found}
  def info(gameId), do: Guild.info(gameId)

  @doc """
  Read all names for a list of guild IDs
  """
  @spec names() :: {:ok, %{String.t() => String.t()}}
  def names(), do: Guild.names()

  @doc """
  Read all names for a list of guild IDs
  """
  @spec names([String.t()]) :: {:ok, %{String.t() => String.t()}}
  def names(ids), do: Guild.names(ids)

  @doc """
  Delete the game from the system
  """
  @spec delete(String.t(), String.t()) :: :ok | {:error, atom}
  def delete(gameId, userId), do: Guild.delete(gameId, userId)

  @doc """
  """
  @spec page(integer, integer) :: {:ok, Storage.pageT()} | {:error, :not_found}
  def page(page, count), do: Guild.page(page, count)

  @doc """
  Read all the apps
  """
  @spec all() :: {:ok, [Storage.guildT()]}
  def all(), do: Guild.all()

  @doc """
  """
  @spec updateName(String.t(), String.t(), String.t()) ::
          {:ok, Storage.guildT()} | {:error, atom}
  def updateName(guildId, userId, name) do
    Guild.updateName(guildId, userId, name)
  end

  @doc """
  """
  @spec updateOwner(String.t(), String.t(), String.t()) ::
          {:ok, Storage.guildT()} | {:error, atom}
  def updateOwner(guildId, userId, ownerId) do
    Guild.updateOwner(guildId, userId, ownerId)
  end

  @doc """
  """
  @spec updateImage(String.t(), String.t(), String.t()) ::
          {:ok, Storage.guildT()} | {:error, atom}
  def updateImage(guildId, userId, url) do
    Guild.updateImage(guildId, userId, url)
  end

  @doc """
  """
  @spec updateDescription(String.t(), String.t(), String.t()) ::
          {:ok, Storage.guildT()} | {:error, atom}
  def updateDescription(guildId, userId, description) do
    Guild.updateDescription(guildId, userId, description)
  end

  @doc """
  """
  @spec updateMeta(String.t(), String.t(), map) ::
          {:ok, Storage.guildT()} | {:error, atom}
  def updateMeta(guildId, userId, meta) do
    Guild.updateMeta(guildId, userId, meta)
  end

  @doc """
  """
  @spec updateUserStake(String.t(), String.t(), String.t(), integer) ::
          {:ok, Storage.guildT()} | {:error, atom}
  def updateUserStake(guildId, ownerId, userId, stake) do
    Guild.updateUserStake(guildId, ownerId, userId, stake)
  end

  @doc """
  """
  @spec addGame(String.t(), String.t(), String.t()) ::
          {:ok, Storage.guildT()} | {:error, atom}
  def addGame(guildId, ownerId, gameId) do
    Guild.addGame(guildId, ownerId, gameId)
  end

  @doc """
  """
  @spec removeGame(String.t(), String.t(), String.t()) ::
          {:ok, Storage.guildT()} | {:error, atom}
  def removeGame(guildId, ownerId, gameId) do
    Guild.removeGame(guildId, ownerId, gameId)
  end

  @doc """
  """
  @spec addUser(String.t(), String.t(), String.t()) ::
          {:ok, Storage.guildT()} | {:error, atom}
  def addUser(guildId, ownerId, userId) do
    Guild.addUser(guildId, ownerId, userId)
  end

  @doc """
  """
  @spec removeUser(String.t(), String.t(), String.t()) ::
          {:ok, Storage.guildT()} | {:error, atom}
  def removeUser(guildId, ownerId, userId) do
    Guild.removeUser(guildId, ownerId, userId)
  end

  @doc """
  """
  @spec balance(String.t(), String.t()) ::
          {:ok, [map]} | {:error, any}
  def balance(gameId, userId) do
    Guild.balance(gameId, userId)
  end

  @doc """
  """
  @spec pay(String.t(), String.t(), String.t(), String.t()) ::
          :ok | {:error, any}
  def pay(_gameId, _userId, "XRP", _amount) do
    {:error, "not_implemented"}
  end

  def pay(_gameId, _userId, "ETH", _amount) do
    {:error, "not_implemented"}
  end

  def pay(_gameId, _userId, "BTC", _amount) do
    {:error, "not_implemented"}
  end

  # ----------------------------------------------------------------------------
  # Private API
  # ----------------------------------------------------------------------------
end
