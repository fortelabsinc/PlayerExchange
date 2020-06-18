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
defmodule Storage.Wallet.XRP do
  @moduledoc ~S"""
  NOTE:

  defmodule Storage.Repo.Migrations.WalletXrp do
    use Ecto.Migration
    def change do
      create table(:xrp) do
        add(:address, :string)
        add(:derivation, :string)
        add(:mnemonic, :string)
        add(:privatekey, :string)
        add(:publickey, :string)
      end

      create(unique_index(:xrp, [:address]))
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
  schema "xrp" do
    field(:address, :string, primary_key: true)
    field(:derivation, :string)
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
  @type t :: %Storage.Wallet.XRP{
          address: String.t(),
          derivation: String.t(),
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
  @spec address(Storage.Wallet.XRP.t()) :: String.t()
  def address(xrpT), do: xrpT.address

  @doc """
  Storage.Work.Posting.t accessor to derivation
  """
  @spec derivation(Storage.Wallet.XRP.t()) :: String.t()
  def derivation(xrpT), do: xrpT.derivation

  @doc """
  Storage.Work.Posting.t accessor to mnemonic
  """
  @spec mnemonic(Storage.Wallet.XRP.t()) :: String.t()
  def mnemonic(xrpT), do: xrpT.mnemonic

  @doc """
  Storage.Work.Posting.t accessor to mnemonic
  """
  @spec privateKey(Storage.Wallet.XRP.t()) :: String.t()
  def privateKey(xrpT), do: xrpT.privatekey

  @doc """
  Storage.Work.Posting.t accessor to mnemonic
  """
  @spec publicKey(Storage.Wallet.XRP.t()) :: String.t()
  def publicKey(xrpT), do: xrpT.publickey

  @doc """
  Storage.Work.Posting.t accessor to meta data
  """
  @spec meta(Storage.Wallet.XRP.t()) :: map
  def meta(xrpT), do: xrpT.meta

  @doc """
  Create a new wallet structure with the
  data passed into via the map.  It is
  assumed that the map structure should look
  like so:

  ```
  %{
    "address" => "String value",
    "derivation" => "String value",
    "mnemonic" => "String value",
    "privatekey" => "String value",
    "publickey" => "String value",
    "meta" => %{}
  }
  ```
  """
  @spec new(map) :: Storage.Wallet.XRP.t()
  def new(map) do
    %Storage.Wallet.XRP{
      address: map["address"],
      derivation: map["derivation"],
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
  @spec write(Storage.Wallet.XRP.t()) :: {:ok, Storage.Wallet.XRP.t()} | {:error, any()}
  def write(xrp) do
    encrypt(xrp) |> Storage.Repo.insert()
  end

  @doc """
  Update the meta value assigned to this address
  """
  @spec updateMeta(String.t(), map) :: {:ok, Storage.Wallet.XRP.t()} | {:error, any()}
  def updateMeta(address, meta) do
    changes = Storage.Repo.changeSetField(%{}, :meta, meta)
    post = Ecto.Changeset.change(%Storage.Wallet.XRP{address: address}, changes)

    case Storage.Repo.update(post) do
      {:error, changeset} = err ->
        Logger.error("[Storage.Wallet.XRP.updateMeta] Failed #{inspect(changeset)}")
        err

      results ->
        results
    end
  end

  ## ----------------------------------------------------------------------------
  ## Query Operations
  ## ----------------------------------------------------------------------------

  @doc """
  Pull all the users from the system.  The cost of this call will grow with the
  total number of users in the system.  It will require a DB read
  """
  @spec query :: [Storage.Wallet.XRP.t()]
  def query() do
    Storage.Repo.all(Storage.Wallet.XRP)
    |> decrypt()
  end

  @doc """
  Pulls an address info out of the DB.
  """
  @spec query(String.t()) :: nil | Storage.Wallet.XRP.t()
  def query(address) do
    Storage.Repo.get_by(Storage.Wallet.XRP, address: address)
    |> decrypt()
  end

  @doc """
  Pull all the users from the system.  The cost of this call will grow with the
  total number of users in the system.  It will require a DB read.any()

  NOTE: This will not decrypt the data in the DB.  This is useful for pulling
        data that might be publicly viewable.  This call is also
        faster because it doesn't have to decrypt data
  """
  @spec queryRaw :: [Storage.Wallet.XRP.t()]
  def queryRaw() do
    Storage.Repo.all(Storage.Wallet.XRP)
  end

  @doc """
  Pulls an address info out of the DB.

  NOTE: This will not decrypt the data in the DB.  This is useful for pulling
        data that might be publicly viewable.  This call is also
        faster because it doesn't have to decrypt data
  """
  @spec queryRaw(String.t()) :: nil | Storage.Wallet.XRP.t()
  def queryRaw(address) do
    Storage.Repo.get_by(Storage.Wallet.XRP, address: address)
    |> decrypt()
  end

  # ----------------------------------------------------------------------------
  # Private API
  # ----------------------------------------------------------------------------

  # Encrypt some data.
  defp encrypt(nil), do: nil

  defp encrypt(entries) when is_list(entries) do
    Enum.map(entries, fn xrp -> encrypt(xrp) end)
  end

  defp encrypt(xrp) do
    %{
      xrp
      | derivation: Utils.Crypto.encrypt(xrp.derivation) |> Base.encode64(),
        mnemonic: Utils.Crypto.encrypt(xrp.mnemonic) |> Base.encode64(),
        privatekey: Utils.Crypto.encrypt(xrp.privatekey) |> Base.encode64(),
        publickey: Utils.Crypto.encrypt(xrp.publickey) |> Base.encode64()
    }
  end

  # Decrypt some data
  defp decrypt(nil), do: nil

  defp decrypt(entries) when is_list(entries) do
    Enum.map(entries, fn xrp -> decrypt(xrp) end)
  end

  defp decrypt(xrp) do
    %{
      xrp
      | derivation: Base.decode64!(xrp.derivation) |> Utils.Crypto.decrypt(),
        mnemonic: Base.decode64!(xrp.mnemonic) |> Utils.Crypto.decrypt(),
        privatekey: Base.decode64!(xrp.privatekey) |> Utils.Crypto.decrypt(),
        publickey: Base.decode64!(xrp.publickey) |> Utils.Crypto.decrypt()
    }
  end
end
