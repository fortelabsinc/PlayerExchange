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
  import Ecto.Query

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
    timestamps(type: :naive_datetime, autogenerate: {Storage.Repo, :timestamps, []})
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
          inserted_at: NativeDateTime.t(),
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
          String.t(),
          integer(),
          map
        ) :: Storage.Work.Posting.t()
  @doc """
  """
  def new(
        postId,
        userId,
        gameId,
        details,
        confType,
        confAmt,
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
      post_id: postId,
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

  def new(map) do
    %Storage.Work.Posting{
      post_id: UUID.uuid4(),
      user_id: map["user_id"],
      meta: map["meta"],
      game_id: map["game_id"],
      details: map["details"],
      state: "open",
      confirm_pay_type: map["conf_type"],
      confirm_pay_amt: map["conf_amt"],
      complete_pay_type: map["comp_type"],
      complete_pay_amt: map["comp_amt"],
      bonus_pay_amt: map["bonus_amt"],
      bonus_pay_type: map["bonus_type"],
      bonus_req: map["bonus_req"],
      user_count_req: map["user_count"],
      type_req: map["type"]
    }
  end

  ## ----------------------------------------------------------------------------
  ## Write Operations
  ## ----------------------------------------------------------------------------

  @doc """
  Write the specific posting to the database
  """
  @spec write(Storage.Work.Posting.t()) :: {:ok, Storage.Work.Posting.t()} | {:error, any()}
  def write(posting), do: Storage.Repo.insert(posting)

  @doc """
  Delete all posting from a user
  """
  @spec delete(String.t()) :: :ok
  def delete(user_id) do
    from(p in Storage.Work.Posting, where: p.user_id == ^user_id)
    |> Storage.Repo.delete_all()

    :ok
  end

  @doc """
  Delete a posting from a user
  """
  @spec delete(String.t(), String.t()) :: :ok
  def delete(user_id, post_id) do
    from(p in Storage.Work.Posting, where: p.user_id == ^user_id and p.post_id == ^post_id)
    |> Storage.Repo.delete_all()

    :ok
  end

  ## ----------------------------------------------------------------------------
  ## Query Operations
  ## ----------------------------------------------------------------------------

  @doc """
  Pull all the users from the system.  The cost of this call will grow with the
  total number of users in the system.  It will require a DB read
  """
  @spec queryAll :: [Storage.Work.Posting.t()]
  def queryAll() do
    Storage.Repo.all(Storage.Work.Posting)
  end

  @doc """
  Pulls a User recorded based on the given name.  This will require a DB operation
  however it will only pull the one record
  """
  @spec queryByUser(String.t()) :: nil | [Storage.Work.Posting.t()]
  def queryByUser(user_id) do
    from(p in Storage.Work.Posting, where: p.user_id == ^user_id)
    |> Storage.Repo.all()
  end

  @doc """
  Pulls a Post recorded based on the given post id.  This will require a
  DB operation however it will only pull the one record
  """
  @spec queryByPostId(String.t()) :: nil | Storage.Work.Posting.t()
  def queryByPostId(id) do
    Storage.Repo.get_by(Storage.Work.Posting, post_id: id)
  end

  @doc """
  Reads out a page from the system.  This is showing ALL
  guilds in the system
  """
  @spec queryPage(non_neg_integer, non_neg_integer) ::
          {:ok,
           %{
             count: any,
             first_idx: number,
             last_idx: any,
             last_page: number,
             list: [Storage.Work.Posting.t()],
             next: boolean,
             next_page: number,
             page: number,
             prev: boolean
           }}
  def queryPage(page, count) do
    rez =
      Storage.Work.Posting
      |> order_by(desc: :id)
      |> Storage.Repo.page(page, count)
      |> parsePage()

    {:ok, rez}
  end

  @doc """
  """
  @spec queryUserPage(String.t(), non_neg_integer, non_neg_integer) ::
          {:ok,
           %{
             count: any,
             first_idx: number,
             last_idx: any,
             last_page: number,
             list: [Storage.Work.Posting.t()],
             next: boolean,
             next_page: number,
             page: number,
             prev: boolean
           }}
  def queryUserPage(user_id, page, count) do
    rez =
      from(p in Storage.Work.Posting, where: p.user_id == ^user_id)
      |> order_by(desc: :id)
      |> Storage.Repo.page(page, count)
      |> parsePage()

    {:ok, rez}
  end

  # ----------------------------------------------------------------------------
  # Private API
  # ----------------------------------------------------------------------------

  defp parsePage(data), do: data
end
