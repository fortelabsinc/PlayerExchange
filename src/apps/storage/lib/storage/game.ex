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

  # ----------------------------------------------------------------------------
  # Public API
  # ----------------------------------------------------------------------------

  @doc """
  Job Posting definition.  This is the record type that will be written/read
  from the database.
  """
  @primary_key false
  schema "games" do
    field(:name, :string, primary_key: true)
    field(:image, :string)
    field(:info, :string)
  end

  # ----------------------------------------------------------------------------
  # Storage.Game.t  Struct definition and accessors and settors
  # ----------------------------------------------------------------------------

  # The basic struct returned from the table.  For now I am just going
  # to use this struct directly however I did add accessors so that
  # it can be used without having to know the actual key names
  # incase I change them in the future
  @type t :: %Storage.Game{
          name: String.t(),
          image: String.t(),
          info: String.t()
        }

  @doc """
  Storage.Game.t accessor to name
  """
  @spec name(Storage.Game.t()) :: String.t()
  def name(gameT), do: gameT.name

  @doc """
  Storage.Game.t accessor to image URL
  """
  @spec image(Storage.Game.t()) :: String.t()
  def image(gameT), do: gameT.image

  @doc """
  Storage.Game.t accessor to info
  """
  @spec info(Storage.Game.t()) :: String.t()
  def info(gameT), do: gameT.info

  @spec new(String.t(), String.t(), String.t()) :: Storage.Game.t()
  def new(name, image, info) do
    %Storage.Game{
      name: name,
      image: image,
      info: info
    }
  end

  @spec new(map) :: Storage.Game.t()
  def new(map) do
    %Storage.Game{
      name: map["name"],
      image: map["image"],
      info: map["info"]
    }
  end

  # ----------------------------------------------------------------------------
  # Insertion Commands
  # ----------------------------------------------------------------------------

  @spec write(Storage.Game.t()) :: {:ok, Storage.Game.t()} | {:error, any()}
  def write(xrp), do: Storage.Repo.insert(xrp)

  ## ----------------------------------------------------------------------------
  ## Query Operations
  ## ----------------------------------------------------------------------------

  @doc """
  Pull all the users from the system.  The cost of this call will grow with the
  total number of users in the system.  It will require a DB read
  """
  @spec queryAll :: [Storage.Game.t()]
  def queryAll() do
    Storage.Repo.all(Storage.Game)
  end

  @doc """
  Pulls a User recorded based on the given name.  This will require a DB operation
  however it will only pull the one record
  """
  @spec queryByName(String.t()) :: nil | Storage.Auth.User.t()
  def queryByName(name) do
    Storage.Repo.get_by(Storage.Game, name: name)
  end
end
