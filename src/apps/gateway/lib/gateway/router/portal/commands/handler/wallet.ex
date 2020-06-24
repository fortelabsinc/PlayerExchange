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
defmodule Gateway.Router.Portal.Commands.Handler.Wallet do
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
  Looks up your balance from the system.
  """
  @spec balances(String.t()) :: {:ok, [map]} | {:error, String.t()}
  def balances(username) do
    getBalanceForUsername(username)
  end

  @doc """
  Make a payment to a payID
  """
  @spec payment(String.t(), String.t(), String.t(), String.t()) ::
          {:error, String.t()} | {:ok, String.t()}
  def payment(amt, type, username, payId) do
    info =
      Blockchain.Ripple.PayID.format(username)
      |> Blockchain.Ripple.PayID.lookupAddress(type)

    case info do
      {:ok, from} ->
        case type do
          "XRP" ->
            # Lookup the address info
            case Storage.Wallet.XRP.query(from) do
              nil ->
                {:error, "wallet not found"}

              wallet ->
                # Now Let's lookup the receiver wallet address
                case Blockchain.Ripple.PayID.lookupAddress(payId, type) do
                  {:ok, to} ->
                    mnemonic = Storage.Wallet.XRP.mnemonic(wallet)
                    # now let's pay this out
                    amt = String.to_integer(amt) * 1_000_000
                    Blockchain.Ripple.XRP.pay("#{amt}", mnemonic, to)

                  _ ->
                    {:error, "could not find PayID #{payId}"}
                end
            end

          "ETH" ->
            case Storage.Wallet.Eth.query(from) do
              nil ->
                {:error, "wallet not found"}

              wallet ->
                # Now Let's lookup the receiver wallet address
                case Blockchain.Ripple.PayID.lookupAddress(payId, type) do
                  {:ok, to} ->
                    # now let's pay this out
                    amt = String.to_integer(amt)
                    Blockchain.Eth.pay("#{amt}", wallet.address, to, wallet.privatekey)

                  _ ->
                    {:error, "could not find PayID #{payId}"}
                end
            end

          "BTC" ->
            {:error, :not_implemented}
        end

      _ ->
        {:error, "could not get PayID wallet"}
    end
  end

  @doc """
  Pay off the posting confirmation amount
  """
  @spec payPostingConfirm(String.t(), String.t(), String.t()) ::
          {:error, any} | {:ok, String.t()}
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

  @doc """
  Pay off the posting complete amount
  """
  @spec payPostingComplete(String.t(), String.t(), String.t()) ::
          {:error, any} | {:ok, String.t()}
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

  @doc """
  Pay off the posting bound amount
  """
  @spec payPostingBonus(String.t(), String.t(), String.t()) ::
          {:error, any} | {:ok, String.t()}
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

  # ----------------------------------------------------------------------------
  # Public Auth APIs
  # ----------------------------------------------------------------------------

  # Lets pay off a posting
  defp payPostingAmount(username, postT, payId, amt) do
    # Verify that the user owns the post
    if username == Storage.Work.Posting.userId(postT) do
      info =
        Blockchain.Ripple.PayID.format(username)
        |> Blockchain.Ripple.PayID.lookup()

      case info do
        {:ok, rsp} ->
          from =
            Map.get(rsp, "addressDetails")
            |> Map.get("address")

          # Lookup the address info
          case Storage.Wallet.XRP.query(from) do
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

  # Let's get the balances for these users
  defp getBalanceForUsername(username) do
    Blockchain.Ripple.PayID.format(username)
    |> Blockchain.walletBalances()
  end
end
