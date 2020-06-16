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
defmodule Storage.Wallet.Eth do
  @moduledoc ~S"""
  NOTE:

  defmodule Storage.Repo.Migrations.WalletEth do
    use Ecto.Migration
    def change do
      create table(:eth) do
        add(:address, :eth)
        add(:mnemonic, :eth)
        add(:privatekey, :eth)
        add(:publickey, :eth)
      end

      create(unique_index(:eth, [:address]))
    end
  end
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
  schema "eth" do
    field(:address, :string, primary_key: true)
    field(:mnemonic, :string)
    field(:privatekey, :string)
    field(:publickey, :string)
    field(:meta, :map)
    timestamps(type: :naive_datetime, autogenerate: {Storage.Repo, :timestamps, []})
  end

  # ----------------------------------------------------------------------------
  # Storage.Auth.Posting.t  Struct definition and accessors and settors
  # ----------------------------------------------------------------------------

  # The basic struct returned from the table.  For now I am just going
  # to use this struct directly however I did add accessors so that
  # it can be used without having to know the actual key names
  # incase I change them in the future
  @type t :: %Storage.Wallet.Eth{
          address: String.t(),
          mnemonic: String.t(),
          privatekey: String.t(),
          publickey: String.t(),
          meta: map,
          inserted_at: NativeDateTime.t(),
          updated_at: NativeDateTime.t()
        }

  @doc """
  Storage.Work.Posting.t accessor to address
  """
  @spec address(Storage.Wallet.Eth.t()) :: String.t()
  def address(ethT), do: ethT.address

  @doc """
  Storage.Work.Posting.t accessor to mnemonic
  """
  @spec mnemonic(Storage.Wallet.Eth.t()) :: String.t()
  def mnemonic(ethT), do: ethT.mnemonic

  @doc """
  Storage.Work.Posting.t accessor to mnemonic
  """
  @spec privateKey(Storage.Wallet.Eth.t()) :: String.t()
  def privateKey(ethT), do: ethT.privatekey

  @doc """
  Storage.Work.Posting.t accessor to mnemonic
  """
  @spec publicKey(Storage.Wallet.Eth.t()) :: String.t()
  def publicKey(ethT), do: ethT.publickey

  @doc """
  Storage.Work.Posting.t accessor to meta data
  """
  @spec meta(Storage.Wallet.Eth.t()) :: map
  def meta(ethT), do: ethT.meta

  @doc """
  Create a new wallet structure with the
  data passed into via the map.  It is
  assumed that the map structure should look
  like so:

  ```
  %{
    "address" => "String value",
    "mnemonic" => "String value",
    "privatekey" => "String value",
    "publickey" => "String value",
    "meta" => %{}
  }
  ```
  """
  @spec new(map) :: Storage.Wallet.Eth.t()
  def new(map) do
    %Storage.Wallet.Eth{
      address: map["address"],
      mnemonic: map["mnemonic"],
      privatekey: map["privateKey"],
      publickey: map["publicKey"],
      meta: %{}
    }
  end

  # ----------------------------------------------------------------------------
  # Insertion Commands
  # ----------------------------------------------------------------------------

  @doc """
  Write the record to the database
  """
  @spec write(Storage.Wallet.Eth.t()) :: {:ok, Storage.Wallet.Eth.t()} | {:error, any()}
  def write(eth) do
    %{
      eth
      | mnemonic: Utils.Crypto.encrypt(eth.mnemonic),
        privatekey: Utils.Crypto.encrypt(eth.privatekey),
        publickey: Utils.Crypto.encrypt(eth.publickey)
    }
    |> Storage.Repo.insert()
  end

  @doc """
  Update the meta value assigned to this address
  """
  @spec updateMeta(String.t(), map) :: {:ok, Storage.Wallet.Eth.t()} | {:error, any()}
  def updateMeta(address, meta) do
    changes = Storage.Repo.changeSetField(%{}, :meta, meta)
    post = Ecto.Changeset.change(%Storage.Wallet.Eth{address: address}, changes)

    case Storage.Repo.update(post) do
      {:error, changeset} = err ->
        Logger.error("[Storage.Wallet.Eth.updateMeta] Failed #{inspect(changeset)}")
        err

      results ->
        results
    end
  end

  ## ----------------------------------------------------------------------------
  ## Query Operations
  ## ----------------------------------------------------------------------------

  # @doc """
  # Pull all the users from the system.  The cost of this call will grow with the
  # total number of users in the system.  It will require a DB read
  # """
  @spec query :: [Storage.Wallet.Eth.t()]
  def query() do
    Storage.Repo.all(Storage.Wallet.Eth)
    |> decrypt()
  end

  @doc """
  Pulls an address info out of the DB.
  """
  @spec query(String.t()) :: nil | Storage.Wallet.Eth.t()
  def query(address) do
    Storage.Repo.get_by(Storage.Wallet.Eth, address: address)
    |> decrypt()
  end

  # ----------------------------------------------------------------------------
  # Private API
  # ----------------------------------------------------------------------------

  # Encrypt some data.
  defp encrypt(nil), do: nil

  defp encrypt(entries) when is_list(entries) do
    Enum.map(entries, fn eth -> encrypt(eth) end)
  end

  defp encrypt(eth) do
    %{
      eth
      | mnemonic: Utils.Crypto.encrypt(eth.mnemonic),
        privatekey: Utils.Crypto.encrypt(eth.privatekey),
        publickey: Utils.Crypto.encrypt(eth.publickey)
    }
  end

  # Decrypt some data
  defp decrypt(nil), do: nil

  defp decrypt(entries) when is_list(entries) do
    Enum.map(entries, fn eth -> decrypt(eth) end)
  end

  defp decrypt(eth) do
    %{
      eth
      | mnemonic: Utils.Crypto.decrypt(eth.mnemonic),
        privatekey: Utils.Crypto.decrypt(eth.privatekey),
        publickey: Utils.Crypto.decrypt(eth.publickey)
    }
  end
end
