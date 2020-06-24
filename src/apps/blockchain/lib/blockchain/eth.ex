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
defmodule Blockchain.Eth do
  @moduledoc ~S"""
  Module for talking to the Ethereum blockchain
  """

  require Logger
  import Utils.Build
  use Tesla

  # ----------------------------------------------------------------------------
  # Module Consts
  # ----------------------------------------------------------------------------
  if_prod do
    @serverName "http://ether." <>
                  Application.get_env(:blockchain, :namespace, "forte-player-exchange-dev") <>
                  ".svc.cluster.local:3001"
  else
    @serverName "http://localhost:3001"
  end

  # ----------------------------------------------------------------------------
  # Plug options
  # ----------------------------------------------------------------------------
  plug(Tesla.Middleware.BaseUrl, @serverName)
  plug(Tesla.Middleware.JSON)
  plug(Tesla.Middleware.Headers, [{"Content-Type", "application/json"}])

  # ----------------------------------------------------------------------------
  # Public API
  # ----------------------------------------------------------------------------

  def test() do
    %{
      "address" => "0xdb8bf403da7cfd6d7fced1d6e37b9d743c33c5c3",
      "privateKey" => "0xad207ff9c5308e44d295de82faf53ff793e467845128cb1be5638bc8785cee16",
      "publicKey" =>
        "0x877045a72fbc532cf5d67e202dd09c77cf9621b1c7d7fe4f79b05a277713c2596891f62a448b14c81db4b6af69a04fc60b7f091228e7f2521b729d87cec492a9"
    }
  end

  @doc """
  Converts Eth to Wei
  """
  @spec weiToEther(number) :: number
  def weiToEther(wei), do: wei / 1_000_000_000_000_000_000

  @doc """
  Converts Wei to Eth
  """
  @spec etherToWei(number) :: number
  def etherToWei(eth), do: eth * 1_000_000_000_000_000_000

  @doc """
  Check to make sure we have a full connection to the rippler server
  """
  @spec health :: {:error, String.t()} | :ok
  def health() do
    case get("/node/healthy") do
      {:ok, rsp} ->
        case rsp.status do
          200 -> :ok
          _ -> {:error, rsp.body}
        end

      rsp ->
        rsp
    end
  end

  @doc """
  Check the XRP blockchain balance.  For XRP you need at least 35 XRP at
  and address for it to return a valid balance.  As such we are assuming
  that if the "NOT_FOUND" is withing all the html crap that is returned
  we will assumed that the balance is 34 or less and return 0.

  Returns:

  {:ok, balance}: balance is a string with the number of XRP drops

  TODO:  Make is show in XRP format
  """
  @spec balance(String.t()) :: {:error, any} | {:ok, String.t()}
  def balance(address) do
    case get("/wallet/balance/kovan/#{address}") do
      {:ok, rsp} ->
        if String.contains?(rsp.body, "NOT_FOUND") do
          {:ok, "0"}
        else
          {:ok, rsp.body}
        end

      rsp ->
        rsp
    end
  end

  @doc """
  Pulls the transaction history for an address.

  Returns:
  {:ok, history}

  history = [
    %{
     "account" => "rhtGxAAnuvE5ustTKFsdj1P1xZXz8gvsmb",
     "fee" => "10",
     "hash" => "1194336E2FC958F349FBB9FD64CA421EF26DD48204A4343E33727A3220A52E31",
     "lastLedgerSequence" => 6831879,
     "paymentFields" => %{
       "amount" => %{"drops" => "59999980"},
       "destination" => "rfxJaXeKMsMu8x1k7SY3ZnwQtZ4ya5sQJR"
     },
     "sequence" => 4,
     "signingPublicKey" => %{ ... },
     "timestamp" => 1588551051,
     "transactionSignature" => %{...}
     "type" => 0
   },
   <additional transactions>
  ]
  """
  @spec history(any) :: {:error, any} | {:ok, any}
  def history(address) do
    case get("/wallet/history/#{address}") do
      {:ok, rsp} ->
        {:ok, rsp.body}

      rsp ->
        rsp
    end
  end

  @doc """
  Pulls the transaction data that matchs a hash for a given account

  Returns:
  {:ok, transaction}

  transaction = %{
    "account" => "rhtGxAAnuvE5ustTKFsdj1P1xZXz8gvsmb",
    "fee" => "10",
    "hash" => "1194336E2FC958F349FBB9FD64CA421EF26DD48204A4343E33727A3220A52E31",
    "lastLedgerSequence" => 6831879,
    "paymentFields" => %{
      "amount" => %{"drops" => "59999980"},
      "destination" => "rfxJaXeKMsMu8x1k7SY3ZnwQtZ4ya5sQJR"
    },
    "sequence" => 4,
    "signingPublicKey" => %{ ... },
    "timestamp" => 1588551051,
    "transactionSignature" => %{...}
    "type" => 0
  }
  """
  @spec payment(String.t(), String.t()) :: {:error, any} | {:ok, map}
  def payment(_wallet, hash) do
    case get("/wallet/payment/kovan/#{hash}") do
      {:ok, rsp} ->
        {:ok, rsp.body}

      rsp ->
        rsp
    end
  end

  @doc """
  Pulls the status of a transaction. This doesn't seem to be working so
  no good data here.
  """
  @spec status(any) :: {:error, any} | {:ok, any}
  def status(hash) do
    case get("/wallet/status/#{hash}") do
      {:ok, rsp} ->
        {:ok, rsp.body}

      rsp ->
        rsp
    end
  end

  @doc """
  Create a new XRP wallet on the Testnet

  Returns:

  {:ok, res}: Res is a map in the following format
  ```
   %{
   "address" => "XRP Address",
   "derivation" => "<String value>",
   "mnemonic" => "<string value>",
   "privateKey" => "<private key>",
   "publicKey" => "<public key>"
  }
  ```
  """
  @spec create :: {:error, any} | {:ok, map}
  def create() do
    case post("/wallet/create/kovan", "") do
      {:ok, rsp} ->
        {:ok, rsp.body}

      rsp ->
        rsp
    end
  end

  @doc """
  Sends a payment to a given address.

  NOTES:

  The system work in Drops.  Drops to XRP: amount * 1000000 or

  in XRP
  "123"

  Returns:

  {:ok, hash}: The transaction hash for the send
  ```
   %{
   "address" => "XRP Address",
   "derivation" => "<String value>",
   "mnemonic" => "<string value>",
   "privateKey" => "<private key>",
   "publicKey" => "<public key>"
  }
  ```
  """
  @spec pay(String.t(), String.t(), String.t(), String.t()) :: {:error, any} | {:ok, String.t()}
  def pay(amount, from, to, privateKey) do
    data = %{
      amount: amount,
      from: from,
      to: to,
      privateKey: privateKey
    }

    case post("/wallet/send/kovan", data) do
      {:ok, rsp} ->
        {:ok, rsp.body}

      rsp ->
        rsp
    end
  end
end
