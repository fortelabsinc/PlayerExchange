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
defmodule Storage.Work.Posting do
  @moduledoc ~S"""
  Jobs board postings data management.  All this data will be stored in ecto.
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
  schema "postings" do
    field(:post_id, :string, primary_key: true)
    field(:user_id, :string)
    field(:assigned_id, :string)
    field(:meta, :map)
    field(:game_id, :string)
    field(:details, :string)
    field(:state, :string)
    field(:expired_at, :naive_datetime)
    field(:meetup_at, :naive_datetime)
    field(:confirm_pay_amt, :string)
    field(:confirm_pay_type, :string)
    field(:complete_pay_amt, :string)
    field(:complete_pay_type, :string)
    field(:bonus_pay_amt, :string)
    field(:bonus_pay_type, :string)
    field(:bonus_req, :string)
    field(:level_req, :string)
    field(:class_req, :string)
    field(:user_count_req, :integer)
    field(:type_req, :string)
    field(:created_at, :naive_datetime)
    field(:updated_at, :naive_datetime)
  end

  # ----------------------------------------------------------------------------
  # Storage.Auth.Posting.t  Struct definition and accessors and settors
  # ----------------------------------------------------------------------------

  # The basic struct returned from the table.  For now I am just going
  # to use this struct directly however I did add accessors so that
  # it can be used without having to know the actual key names
  # incase I change them in the future
  @type t :: %Storage.Work.Posting{
          post_id: String.t(),
          user_id: String.t(),
          assigned_id: String.t(),
          meta: map,
          game_id: String.t(),
          details: String.t(),
          state: String.t(),
          expired_at: NativeDateTime.t(),
          meetup_at: NativeDateTime.t(),
          confirm_pay_type: String.t(),
          confirm_pay_amt: String.t(),
          complete_pay_type: String.t(),
          complete_pay_amt: String.t(),
          bonus_pay_amt: String.t(),
          bonus_pay_type: String.t(),
          bonus_req: String.t(),
          level_req: String.t(),
          class_req: String.t(),
          user_count_req: integer(),
          type_req: String.t(),
          created_at: NativeDateTime.t(),
          updated_at: NativeDateTime.t()
        }

  @doc """
  Storage.Work.Posting.t accessor to postId
  """
  @spec postId(Storage.Work.Posting.t()) :: String.t()
  def postId(postT), do: postT.post_id

  @doc """
  Storage.Work.Posting.t accessor the user who posted this work
  """
  @spec userId(Storage.Work.Posting.t()) :: String.t()
  def userId(postT), do: postT.user_id

  @doc """
  Storage.Work.Posting.t accessor the user who posted this work
  """
  @spec assignedTo(Storage.Work.Posting.t()) :: String.t()
  def assignedTo(postT), do: postT.assigned_id

  @doc """
  """
  @spec meta(Storage.Work.Posting.t()) :: map
  def meta(postT), do: postT.meta

  @doc """
  """
  @spec gameId(Storage.Work.Posting.t()) :: String.t()
  def gameId(postT), do: postT.game_id

  @doc """
  """
  @spec details(Storage.Work.Posting.t()) :: String.t()
  def details(postT), do: postT.details

  @doc """
  """
  @spec state(Storage.Work.Posting.t()) :: String.t()
  def state(postT), do: postT.state

  @doc """
  """
  @spec expiresTime(Storage.Work.Posting.t()) :: NativeDateTime.t()
  def expiresTime(postT), do: postT.expired_at

  @doc """
  """
  @spec meetTime(Storage.Work.Posting.t()) :: NativeDateTime.t()
  def meetTime(postT), do: postT.meetup_at

  @doc """
    "XRP"
    "BTC"
    "ETH"
  """
  @spec confirmPayType(Storage.Work.Posting.t()) :: String.t()
  def(confirmPayType(postT), do: postT.confirm_pay_type)

  @doc """
  """
  @spec confirmPayAmt(Storage.Work.Posting.t()) :: String.t()
  def confirmPayAmt(postT), do: postT.confirm_pay_amt

  @doc """
    "XRP"
    "BTC"
    "ETH"
  """
  @spec completePayType(Storage.Work.Posting.t()) :: String.t()
  def completePayType(postT), do: postT.complete_pay_type

  @doc """
  """
  @spec completePayAmt(Storage.Work.Posting.t()) :: String.t()
  def completePayAmt(postT), do: postT.complete_pay_amt

  @doc """
  """
  @spec bonusPayAmt(Storage.Work.Posting.t()) :: String.t()
  def bonusPayAmt(postT), do: postT.bonus_pay_amt

  @doc """
    "XRP"
    "BTC"
    "ETH"
  """
  @spec bonusPayType(Storage.Work.Posting.t()) :: String.t()
  def bonusPayType(postT), do: postT.bonus_pay_type

  @doc """
  """
  @spec bonusRequirement(Storage.Work.Posting.t()) :: String.t()
  def bonusRequirement(postT), do: postT.bonus_req

  @doc """
  """
  @spec levelRequirement(Storage.Work.Posting.t()) :: String.t()
  def levelRequirement(postT), do: postT.level_req

  @doc """
  """
  @spec classRequirement(Storage.Work.Posting.t()) :: String.t()
  def classRequirement(postT), do: postT.class_req

  @doc """
  """
  @spec numUsersRequirement(Storage.Work.Posting.t()) :: integer()
  def numUsersRequirement(postT), do: postT.user_count_req

  @doc """
    "group"
    "individual"
  """
  @spec type(Storage.Work.Posting.t()) :: String.t()
  def type(postT), do: postT.type_req

  @doc """
  """
  @spec createdAt(Storage.Work.Posting.t()) :: NativeDateTime.t()
  def createdAt(postT), do: postT.created_at

  @doc """
  """
  @spec updatedAt(Storage.Work.Posting.t()) :: NativeDateTime.t()
  def updatedAt(postT), do: postT.updated_at

  # ----------------------------------------------------------------------------
  # Insertion Commands
  # ----------------------------------------------------------------------------

  @spec new(
          String.t(),
          String.t(),
          String.t(),
          String.t(),
          String.t(),
          String.t(),
          String.t(),
          String.t(),
          String.t(),
          String.t(),
          String.t(),
          integer(),
          map
        ) :: Storage.Work.Posting.t()
  @doc """
  """
  def new(
        userId,
        gameId,
        details,
        confAmt,
        confType,
        compType,
        compAmt,
        bonusType,
        bonusAmt,
        bonusReq,
        userCount,
        type,
        meta \\ %{}
      ) do
    %Storage.Work.Posting{
      user_id: userId,
      meta: meta,
      game_id: gameId,
      details: details,
      state: "open",
      confirm_pay_type: confType,
      confirm_pay_amt: confAmt,
      complete_pay_type: compType,
      complete_pay_amt: compAmt,
      bonus_pay_amt: bonusAmt,
      bonus_pay_type: bonusType,
      bonus_req: bonusReq,
      user_count_req: userCount,
      type_req: type
    }
  end

  @spec write(Storage.Work.Posting.t()) :: {:ok, Storage.Work.Posting.t()} | {:error, any()}
  def write(posting), do: Storage.Repo.insert(posting)

  ## ----------------------------------------------------------------------------
  ## Query Operations
  ## ----------------------------------------------------------------------------

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
