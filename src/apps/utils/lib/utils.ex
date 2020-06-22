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
defmodule Utils do
  @moduledoc """
  Some basic utils information.  Frankly I don't know what I am going to put
  here...
  """

  @doc """
  Pull the current build number out of the system.  This can be used to disply
  the current build of the application being hosted, etc
  """
  @spec buildVersion() :: String.t()
  def buildVersion(), do: Application.spec(:utils, :vsn) |> to_string()

  @doc """
  When a build is done on the CICD system it will record the git commit hash
  for it in the config values.  This will allow you access to that data
  to verify that you are running the expected version, etc
  """
  @spec buildHash() :: String.t()
  def buildHash(), do: Application.get_env(:utils, :build_hash, "0")

  @doc """
  Generate a new UUIDv4 in human readable string format
  """
  @spec uuid4() :: String.t()
  def uuid4(), do: uuid4(:string)

  @doc """
  Generate a new UUIDv4 in string or binary format based
  on the atom given

  ## Args:
  :binary -> Returns the UUID in binary format <<_::128>>
  :string -> Returns the UUID in human readable string format
  """
  @spec uuid4(:binary | :string) :: String.t() | <<_::128>>
  def uuid4(:string), do: UUID.uuid4()
  def uuid4(:binary), do: uuidToBinary(UUID.uuid4())

  @doc """
  Parse a binary UUID into a human readable string format
  """
  @spec uuidToString(<<_::128>>) :: String.t()
  def uuidToString(uuid), do: UUID.binary_to_string!(uuid)

  @doc """
  Parse a String UUID into a binary format
  """
  @spec uuidToBinary(String.t()) :: <<_::128>>
  def uuidToBinary(uuid), do: UUID.string_to_binary!(uuid)

  @doc """
  Convert a Struct into a map
  """
  @spec structToMap(struct() | nil) :: map
  def structToMap(nil), do: nil

  def structToMap(struct) when is_struct(struct) do
    Map.delete(struct, :__meta__) |> Map.delete(:__struct__)
  end
end
