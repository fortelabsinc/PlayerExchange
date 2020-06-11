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
defmodule Blockchain.Ripple.PayID do
  @moduledoc ~S"""
  Manages all the calls to the PayID services
  """

  require Logger
  import Utils.Build
  use Tesla

  # ----------------------------------------------------------------------------
  # Module Consts
  # ----------------------------------------------------------------------------
  if_prod do
    # TODO:  This data should come from the config files
    @serverName "http://payid.default.svc.cluster.local:8081"
  else
    @serverName "http://localhost:8081"
  end

  # ----------------------------------------------------------------------------
  # Plug options
  # ----------------------------------------------------------------------------
  plug(Tesla.Middleware.BaseUrl, @serverName)
  plug(Tesla.Middleware.JSON)

  plug(Tesla.Middleware.Headers, [
    {"Content-Type", "application/json"},
    {"PayID-API-Version", "2020-05-28"}
  ])

  # ----------------------------------------------------------------------------
  # Public API
  # ----------------------------------------------------------------------------

  @doc """
  Format an a username string to be payID safe
  """
  @spec format(String.t()) :: String.t()
  def format(name) do
    String.replace(name, "@", "_")
    |> String.replace(".", "_")
  end

  @doc """
  Looks up a payid account from a public payid server.  This will decode the
  payid format and return a map from the payid server.

  Arguments:
  payID:  String in the form of <username>$<server address>
  type: The blockchain network requested

  Returns:

  Success: {ok, map}
  Map is of the form
  ```
  %{
    "addressDetailType" => "CryptoAddressDetails",
    "addressDetails" => %{
      "address" => "<wallet address>"
    }
  }
  ```
  """
  @spec lookup(String.t(), :xrp_test) ::
          {:ok, map} | {:error, String.t()} | {:error, :invalid_format}
  def lookup(payID, type \\ :xrp_test) do
    accountInfo = String.split(payID, "$")

    case accountInfo do
      [name, server] ->
        {:ok, rsp} =
          Tesla.get("https://#{server}/#{name}",
            headers: [{"Accept", header(type)}, {"PayID-Version", "1.0"}]
          )

        case rsp.status do
          200 ->
            {:ok, Jason.decode!(rsp.body)}

          status ->
            {:error, "status code: #{status}"}
        end

      _ ->
        {:error, :invalid_format}
    end
  end

  @doc """
  Looks up a payid account from the internal payid server.  This will decode
  the payid format and return a map from the payid server.

  Arguments:
  payID:  String in the form of <username>$<server address>

  Returns:

  Success: {ok, map}
  Map is of the form
  ```
   %{
    "addresses" => [
      %{
        "details" => %{
          "address" => "<wallet Address>"
        },
        "environment" => "TESTNET",
        "payment_network" => "XRPL"
      }
    ],
    "pay_id" => "<pay id account name, same that was passed in>"
  }
  ```
  """
  @spec lookupFull(any) ::
          {:error, :bad_request | :not_found | :server_unavailable} | {:ok, map}
  def lookupFull(payID) do
    {:ok, rsp} = get("/users/#{payID}")

    case rsp.status do
      200 -> {:ok, rsp.body}
      400 -> {:error, :bad_request}
      404 -> {:error, :not_found}
      503 -> {:error, :server_unavailable}
    end
  end

  @doc """
  Creates a new PayID account on the interal server

  Arguments:
  payID:  String in the form of <username>$<server address>
  """
  @spec create(String.t(), String.t(), :xrp_test) ::
          :ok | {:error, :bad_request | :in_use | :server_unavailable}
  def create(payID, wallet, type \\ :xrp_test) do
    data = %{
      payId: payID,
      addresses: [
        %{
          paymentNetwork: network(type),
          environment: environment(type),
          details: %{
            address: wallet
          }
        }
      ]
    }

    {:ok, rsp} = post("/users", data)

    case rsp.status do
      201 -> :ok
      400 -> {:error, :bad_request}
      404 -> {:error, :not_found}
      409 -> {:error, :in_use}
      503 -> {:error, :server_unavailable}
    end
  end

  @doc """
  Updates the wallet address assigned to the current payID account

  Arguments:
  payID:  String in the form of <username>$<server address>
  """
  @spec update(String.t(), String.t(), :xrp_test) ::
          :ok | {:error, :bad_request | :in_use | :server_unavailable}
  def update(payID, wallet, type \\ :xrp_test) do
    data = %{
      payId: payID,
      addresses: [
        %{
          paymentNetwork: network(type),
          environment: environment(type),
          details: %{
            address: wallet
          }
        }
      ]
    }

    {:ok, rsp} = put("/users/#{payID}", data)

    case rsp.status do
      200 -> :ok
      201 -> :ok
      400 -> {:error, :bad_request}
      404 -> {:error, :not_found}
      409 -> {:error, :in_use}
      503 -> {:error, :server_unavailable}
    end
  end

  @doc """
  Deletes a PayID from the internal server

  Arguments:
  payID:  String in the form of <username>$<server address>
  """
  @spec remove(String.t()) ::
          :ok | {:error, :bad_request | :not_found | :server_unavailable}
  def remove(payID) do
    {:ok, rsp} = delete("/users/#{payID}")

    case rsp.status do
      200 -> :ok
      204 -> :ok
      400 -> {:error, :bad_request}
      404 -> {:error, :not_found}
      503 -> {:error, :server_unavailable}
    end
  end

  # ----------------------------------------------------------------------------
  # Private API
  # ----------------------------------------------------------------------------

  # Pull out the header address for the network you are looking for
  defp header(:all), do: "application/payid+json"
  defp header(:xrp), do: "application/xrpl-mainnet+json"
  defp header(:xrp_test), do: "application/xrpl-testnet+json"
  defp header(:xrp_dev), do: "application/xrpl-devnet+json"
  defp header(:ach), do: "application/ach+json"
  defp header(:ilp), do: "application/spsp4+json"
  defp header(:btc), do: "application/btc-mainnet+json"
  defp header(:btc_test), do: "application/btc-testnet+json"
  defp header(:eth), do: "application/eth-mainnet+json"
  defp header(:eth_ropsten), do: "application/eth-ropsten+json"
  defp header(:eth_rinkeby), do: "application/eth-rinkeby+json"
  defp header(:eth_goerli), do: "application/eth-goerli+json"
  defp header(:eth_kovan), do: "application/eth-kovan+json"

  defp network(:xrp_test), do: "XRPL"

  defp environment(:xrp_test), do: "TESTNET"
end
