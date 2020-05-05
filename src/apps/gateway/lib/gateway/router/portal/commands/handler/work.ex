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
defmodule Gateway.Router.Portal.Commands.Handler.Work do
  @moduledoc ~S"""
  Processes the HTTP based requests and sends them to the correct handler.

  The handler or business logic is broken out of http request so I can
  change API versions later on but still keep backwards compatability
  support if possible
  """

  require Logger

  # ----------------------------------------------------------------------------
  # Public Auth APIs
  # ----------------------------------------------------------------------------

  @doc """
  Basic setup.  Nothing to do here
  """
  @spec init :: :ok
  def init() do
    :ok
  end

  @doc """
  Get all the postings in a Map format for transmission
  """
  @spec postings() :: [map]
  def postings() do
    Storage.Work.Posting.queryAll()
    |> Enum.map(fn post ->
      Map.drop(post, [:__meta__, :__struct__])
    end)
  end

  @doc """
  Get all the postings in a Map format for transmission
  """
  @spec posting(String.t()) :: {:ok, any} | {:error, String.t()}
  def posting(post_id) do
    case Storage.Work.Posting.queryByPostId(post_id) do
      nil ->
        {:error, "not found"}

      post ->
        post = Map.drop(post, [:__meta__, :__struct__])
        {:ok, post}
    end
  end

  @doc """
  Get all the postings for a single user
  """
  @spec postings(String.t()) :: [map]
  def postings(username) do
    Storage.Work.Posting.queryByUser(username)
    |> Enum.map(fn post ->
      Map.drop(post, [:__meta__, :__struct__])
    end)
  end

  @doc """
  Add a new posting to the system
  """
  @spec addPosting(String.t(), map) :: {:ok, any}
  def addPosting(username, posting) do
    Map.put(posting, "user_id", username)
    |> Storage.Work.Posting.new()
    |> Storage.Work.Posting.write()
  end

  @doc """
  Delete a posting from a specific user
  """
  @spec deletePosting(binary, binary) :: :ok
  def deletePosting(username, postId) do
    Storage.Work.Posting.delete(username, postId)
  end

  @doc """
  Delete all postings by a specific user
  """
  @spec deletePosting(binary) :: :ok
  def deletePosting(username) do
    Storage.Work.Posting.delete(username)
  end

  def payPostingConfirm(postId, username, payId) do
    case Storage.Work.Posting.queryByPostId(postId) do
      nil ->
        {:error, "post not found"}

      postT ->
        amt =
          Storage.Work.Posting.confirmPayAmt(postT)
          |> String.to_integer()

        payPostingAmount(username, postT, payId, "#{amt * 1_000_000}")
    end
  end

  def payPostingComplete(postId, username, payId) do
    case Storage.Work.Posting.queryByPostId(postId) do
      nil ->
        {:error, "post not found"}

      postT ->
        amt =
          Storage.Work.Posting.completePayAmt(postT)
          |> String.to_integer()

        payPostingAmount(username, postT, payId, "#{amt * 1_000_000}")
    end
  end

  def payPostingBonus(postId, username, payId) do
    case Storage.Work.Posting.queryByPostId(postId) do
      nil ->
        {:error, "post not found"}

      postT ->
        amt =
          Storage.Work.Posting.bonusPayAmt(postT)
          |> String.to_integer()

        payPostingAmount(username, postT, payId, "#{amt * 1_000_000}")
    end
  end

  defp payPostingAmount(username, postT, payId, amt) do
    # Verify that the user owns the post
    if username == Storage.Work.Posting.userId(postT) do
      fuser = Blockchain.Ripple.PayID.format(username)
      toPayID = "#{fuser}$forte.playerexchange.io"
      info = Blockchain.Ripple.PayID.lookup(toPayID)

      case info do
        {:ok, rsp} ->
          from =
            Map.get(rsp, "addressDetails")
            |> Map.get("address")

          # Lookup the address info
          case Storage.Wallet.XRP.queryByAddress(from) do
            nil ->
              {:error, "wallet not found"}

            wallet ->
              # Now Let's lookup the receiver wallet address
              case Blockchain.Ripple.PayID.lookup(payId) do
                {:ok, toRsp} ->
                  to =
                    Map.get(toRsp, "addressDetails")
                    |> Map.get("address")

                  mnemonic = Storage.Wallet.XRP.mnemonic(wallet)
                  # now let's pay this out
                  Blockchain.Ripple.XRP.pay(amt, mnemonic, to)

                _ ->
                  {:error, "could not find PayID #{payId}"}
              end
          end

        _ ->
          {:error, "could not get PayID wallet"}
      end
    else
      {:error, "incorrect user"}
    end
  end
end
