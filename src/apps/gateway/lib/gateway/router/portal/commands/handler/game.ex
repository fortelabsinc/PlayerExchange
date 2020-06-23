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
defmodule Gateway.Router.Portal.Commands.Handler.Game do
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
          {:ok, Storage.gameT()} | {:error, any}
  def create(name, owner, image, description) do
    Game.create(name, owner, image, description)
  end

  @doc """
  Get the app info from the billing data
  """
  @spec info(String.t()) :: {:ok, Storage.gameT()} | {:error, :not_found}
  def info(gameId), do: Game.info(gameId)

  @doc """
  Delete the game from the system
  """
  @spec delete(String.t(), String.t()) :: :ok | {:error, atom}
  def delete(gameId, userId), do: Game.delete(gameId, userId)

  @doc """
  """
  @spec page(integer, integer) :: {:ok, Storage.pageT()} | {:error, :not_found}
  def page(page, count), do: Game.page(page, count)

  @doc """
  Read all the apps
  """
  @spec all() :: {:ok, [Storage.gameT()]}
  def all(), do: Game.all()

  @doc """
  """
  @spec updateName(String.t(), String.t(), String.t()) ::
          {:ok, Storage.gameT()} | {:error, :update_failed}
  def updateName(gameId, userId, name) do
    Game.updateName(gameId, userId, name)
  end

  @doc """
  """
  @spec updateOwner(String.t(), String.t(), String.t()) ::
          {:ok, Storage.gameT()} | {:error, :update_failed}
  def updateOwner(gameId, userId, ownerId) do
    Game.updateOwner(gameId, userId, ownerId)
  end

  @doc """
  """
  @spec updateImage(String.t(), String.t(), String.t()) ::
          {:ok, Storage.gameT()} | {:error, :update_failed}
  def updateImage(gameId, userId, url) do
    Game.updateImage(gameId, userId, url)
  end

  @doc """
  """
  @spec updateImage(String.t(), String.t(), String.t()) ::
          {:ok, Storage.gameT()} | {:error, :update_failed}
  def updateDescription(gameId, userId, description) do
    Game.updateDescription(gameId, userId, description)
  end

  @doc """
  """
  @spec updateMeta(String.t(), String.t(), map) ::
          {:ok, Storage.gameT()} | {:error, :update_failed}
  def updateMeta(gameId, userId, meta) do
    Game.updateMeta(gameId, userId, meta)
  end

  @doc """
  """
  @spec balance(String.t(), String.t()) ::
          {:ok, [map]} | {:error, any}
  def balance(gameId, userId) do
    Game.balance(gameId, userId)
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
