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

  THIS IS NOT A WALLET.  IT IS A SHITTY DB ENTRY THAT IS SUPER INSECURE.


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
          publickey: String.t()
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

  @spec new(map) :: Storage.Wallet.XRP.t()
  def new(map) do
    %Storage.Wallet.XRP{
      address: map["address"],
      derivation: map["derivation"],
      mnemonic: map["mnemonic"],
      privatekey: map["privateKey"],
      publickey: map["publicKey"]
    }
  end

  # ----------------------------------------------------------------------------
  # Insertion Commands
  # ----------------------------------------------------------------------------

  @spec write(Storage.Wallet.XRP.t()) :: {:ok, Storage.Wallet.XRP.t()} | {:error, any()}
  def write(xrp), do: Storage.Repo.insert(xrp)

  ## ----------------------------------------------------------------------------
  ## Query Operations
  ## ----------------------------------------------------------------------------

  @doc """
  Pulls an address info out of the DB.
  """
  @spec queryByAddress(String.t()) :: nil | Storage.Wallet.XRP.t()
  def queryByAddress(address) do
    Storage.Repo.get_by(Storage.Wallet.XRP, address: address)
  end

  # @doc """
  # Pull all the users from the system.  The cost of this call will grow with the
  # total number of users in the system.  It will require a DB read
  # """
  # @spec queryAll :: [Storage.Auth.User.t()]
  # def queryAll() do
  #  Storage.Repo.all(Storage.Auth.User)
  # end

  # @doc """
  # Pulls a User recorded based on the given name.  This will require a DB operation
  # however it will only pull the one record
  # """
  # @spec queryByName(String.t()) :: nil | Storage.Auth.User.t()
  # def queryByName(name) do
  #  Storage.Repo.get_by(Storage.Auth.User, username: name)
  # end

  # @doc """
  # Pulls a User recorded based on the given email address.  This will require a
  # DB operation however it will only pull the one record
  # """
  # @spec queryByEmail(String.t()) :: nil | Storage.Auth.User.t()
  # def queryByEmail(email) do
  #  Storage.Repo.get_by(Storage.Auth.User, email: email)
  # end

  # @doc """
  # Pulls a User recorded based on the given user id.  This will require a
  # DB operation however it will only pull the one record
  # """
  # @spec queryById(String.t()) :: nil | Storage.Auth.User.t()
  # def queryById(id) do
  #  Storage.Repo.get_by(Storage.Auth.User, user_id: id)
  # end

  # @doc """
  # Read the Meta data field from the users database who matches the given username

  # Note: You should use this API if you are sure the user exists.  Otherwise
  #      you will just get back an empty map and not know if the map was empty
  #      due to the player not existing OR if the user just has an empty map

  ## Arguments:

  # name = The string username of record to pull meta

  ## Returns

  # %{} map of the meta field

  # TODO:
  # This is currently pulling the full record when really I just
  # want the meta field.  Need to profile and see if it is actually
  # more performant to eat the network bandwidth and serialization
  # time verses say just asking for the single field
  # """
  # @spec queryMetaByName(String.t()) :: %{}
  # def queryMetaByName(name) do
  #  Storage.Repo.get_by(Storage.Auth.User, username: name)
  #  |> getMeta()
  # end

  # @doc """
  # Read the Meta data field from the users database who matches the given email

  # Note: You should use this API if you are sure the user exists.  Otherwise
  #      you will just get back an empty map and not know if the map was empty
  #      due to the player not existing OR if the user just has an empty map

  ## Arguments:

  # name = The string email of record to pull meta

  ## Returns

  # %{} map of the meta field.  Empty map if not found

  # TODO:
  # This is currently pulling the full record when really I just
  # want the meta field.  Need to profile and see if it is actually
  # more performant to eat the network bandwidth and serialization
  # time verses say just asking for the single field
  # """
  # @spec queryMetaByEmail(String.t()) :: %{}
  # def queryMetaByEmail(email) do
  #  Storage.Repo.get_by(Storage.Auth.User, email: email)
  #  |> getMeta()
  # end

  # @doc """
  # Read the Meta data field from the users database who matches the given user ID

  ## Arguments:

  # id = The string id of record to pull meta

  # Note: You should use this API if you are sure the user exists.  Otherwise
  #      you will just get back an empty map and not know if the map was empty
  #      due to the player not existing OR if the user just has an empty map

  ## Returns

  # %{} map of the meta field

  # TODO:
  # This is currently pulling the full record when really I just
  # want the meta field.  Need to profile and see if it is actually
  # more performant to eat the network bandwidth and serialization
  # time verses say just asking for the single field
  # """
  # @spec queryMetaById(String.t()) :: Storage.Auth.User.t()
  # def queryMetaById(id) do
  #  Storage.Repo.get_by(Storage.Auth.User, user_id: id)
  #  |> getMeta()
  # end

  ## ----------------------------------------------------------------------------
  ## Write Operations
  ## ----------------------------------------------------------------------------
  # @doc """
  # Write a record back to the database.  This is a wholistic write the idea being
  # you read the whole record, modify some fields and write the data back to
  # the system.

  # ```
  # Storage.Auth.User.queryById(id)
  # |> Storage.Auth.User.setMeta(%{:name => "hello"})
  # |> Storage.Auth.User.write
  # ```
  # """
  # @spec write(Storage.Auth.User.t()) ::
  #        {:ok, Storage.Auth.User.t()} | {:error, any()}
  # def write(user), do: Storage.Repo.insert(user)

  ## ----------------------------------------------------------------------------
  ## Private Helpers
  ## ----------------------------------------------------------------------------
  # defp getMeta(nil), do: %{}
  # defp getMeta(map), do: Map.get(map, "meta", %{})
end
