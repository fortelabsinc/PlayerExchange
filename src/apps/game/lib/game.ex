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
defmodule Game do
  @moduledoc """
  Main interface module for the Game system.  NOTE:  this for now will just
  do much of the logic for the commands.  Later we can move this API into
  something a bit more encapulated, etc
  """

  require Logger

  # ----------------------------------------------------------------------------
  # Public API
  # ----------------------------------------------------------------------------

  @doc """
  Create a new game in the system
  """
  @spec create(String.t(), String.t(), String.t(), String.t() | float, String.t(), map) ::
          {:ok, Storage.gameT()} | {:error, any}
  def create(name, owner, image, fee, description, meta \\ %{})

  def create(name, owner, image, fee, description, meta) when is_float(fee) do
    create(name, owner, image, Float.to_string(fee), description, meta)
  end

  def create(name, owner, image, fee, description, meta) do
    # Let's create the game wallets
    case Blockchain.createAccount(name) do
      {:ok, payId} ->
        # Let's create the record entry in the database
        # for this guy
        Storage.gameCreate(name, owner, payId, image, fee, description, meta)

      err ->
        err
    end
  end

  @doc """
  Read all the games from the system
  """
  @spec all() :: {:ok, [Storage.gameT()]}
  def all(), do: Storage.games()

  @doc """
  Read a page of apps from the system
  """
  @spec page(non_neg_integer(), non_neg_integer()) ::
          {:ok, Storage.page()} | {:error, any}
  def page(page, count), do: Storage.gamePage(page, count)

  @doc """
  Look up a specific games info
  """
  @spec info(String.t()) ::
          {:ok, Storage.gameT()} | {:error, :not_found}
  def info(gameId) do
    case Storage.game(gameId) do
      nil -> {:error, :not_found}
      data -> {:ok, data}
    end
  end

  @doc """
  Update the name field for the game

  NOTE:  This will only succeed if the owner field matchs the userId
  """
  @spec updateName(String.t(), String.t(), String.t()) ::
          {:ok, map} | {:error, atom}
  def updateName(gameId, userId, name) do
    case Storage.game(gameId) do
      nil ->
        {:error, :not_found}

      data ->
        if data.owner == userId do
          Storage.gameSetName(gameId, name)
        else
          {:error, :not_owner}
        end
    end
  end

  @doc """
  Update the game owner field

  NOTE:  This will only succeed if the owner field matchs the userId
  """
  @spec updateOwner(String.t(), String.t(), String.t()) ::
          {:ok, map} | {:error, atom}
  def updateOwner(gameId, userId, owner) do
    case Storage.game(gameId) do
      nil ->
        {:error, :not_found}

      data ->
        if data.owner == userId do
          # now lets verify that the new owner is also a member
          Storage.gameSetOwner(gameId, owner)
        else
          {:error, :not_owner}
        end
    end
  end

  @doc """
  Update the game image field

  NOTE:  This will only succeed if the owner field matchs the userId
  """
  @spec updateImage(String.t(), String.t(), String.t()) ::
          {:ok, map} | {:error, atom}
  def updateImage(gameId, userId, image) do
    case Storage.game(gameId) do
      nil ->
        {:error, :not_found}

      data ->
        if data.owner == userId do
          # now lets verify that the new owner is also a member
          Storage.gameSetImage(gameId, image)
        else
          {:error, :not_owner}
        end
    end
  end

  @doc """
  Update the game fee

  NOTE:  This will only succeed if the owner field matchs the userId
  """
  @spec updateImage(String.t(), String.t(), String.t() | float()) ::
          {:ok, map} | {:error, atom}
  def updateFee(gameId, userId, fee) do
    case Storage.game(gameId) do
      nil ->
        {:error, :not_found}

      data ->
        if data.owner == userId do
          # now lets verify that the new owner is also a member
          Storage.gameSetFee(gameId, fee)
        else
          {:error, :not_owner}
        end
    end
  end

  @doc """
  Update the game description field

  NOTE:  This will only succeed if the owner field matchs the userId
  """
  @spec updateDescription(String.t(), String.t(), String.t()) ::
          {:ok, map} | {:error, atom}
  def updateDescription(gameId, userId, description) do
    case Storage.game(gameId) do
      nil ->
        {:error, :not_found}

      data ->
        if data.owner == userId do
          # now lets verify that the new owner is also a member
          Storage.gameSetDescription(gameId, description)
        else
          {:error, :not_owner}
        end
    end
  end

  @doc """
  Update the game metat field

  NOTE:  This will only succeed if the owner field matchs the userId
  """
  @spec updateMeta(String.t(), String.t(), String.t()) ::
          {:ok, map} | {:error, atom}
  def updateMeta(gameId, userId, meta) do
    case Storage.game(gameId) do
      nil ->
        {:error, :not_found}

      data ->
        if data.owner == userId do
          # now lets verify that the new owner is also a member
          Storage.gameSetMeta(gameId, meta)
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
  def delete(gameId, userId) do
    case Storage.game(gameId) do
      nil ->
        {:error, :not_found}

      data ->
        if data.owner == userId do
          # now lets verify that the new owner is also a member
          Storage.gameDelete(gameId)
        else
          {:error, :not_owner}
        end
    end
  end

  @doc """
  """
  @spec balance(String.t(), String.t()) ::
          {:ok, [map]} | {:error, any}
  def balance(gameId, userId) do
    case Storage.game(gameId) do
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
