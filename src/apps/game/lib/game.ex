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
  """
  def create(name, owner, image, description, meta \\ %{}) do
    # Let's create the game wallets
    case Blockchain.createAccount(name) do
      {:ok, payId} ->
        # Let's create the record entry in the database
        # for this guy
        Storage.gameCreate(name, owner, payId, image, description, meta)

      err ->
        err
    end
  end

  @doc """
  Read all the games from the system
  """
  def all() do
    :foo
  end

  @doc """
  Look up a specific games info
  """
  def info(_gameID) do
  end

  def updateName(_gameId, _name) do
  end

  def updateOwner(_gameId, _owner) do
  end

  def updateImage(_gameId, _image) do
  end

  def updateDescription(_gameId, _description) do
  end

  def updateMeta(_gameId, _meta) do
  end

  @doc """
  Update the fields in a map.  It is assumed that
  the if any of the following fields are defined
  it will update them

  MapFields:

  ```
  %{
    name: "new string name",
    owner: "user id of who should now own this game",
    image: "string url to the image asset to discribe the gamae",
    description: "String description of the game"
    meta: "new meta map of data"
  }
  ```
  """
  @spec update(String.t(), map) :: {:ok, map} | {:error, String.t()}
  def update(_gameId, _map) do
  end
end
