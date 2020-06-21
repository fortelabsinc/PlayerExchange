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
    @http "https"
    @domain Application.get_env(:blockchain, :payid_domain, "prod.playerexchange.io")
  else
    @serverName "http://127.0.0.1:8081"
    @http "http"
    @domain "127.0.0.1"
  end

  @invalidChars [
    "@",
    " ",
    "+",
    "=",
    "!",
    "|",
    "~",
    "?",
    "@",
    "#",
    "$",
    "%",
    "^",
    "&",
    "*",
    "(",
    "\"",
    ")",
    "\\",
    "/",
    ".",
    ",",
    "`",
    "<",
    ">",
    "{",
    "}",
    "[",
    "]"
  ]

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
  @type chainT ::
          :xrp
          | :xrp_test
          | :xrp_dev
          | :ach
          | :ilp
          | :btc
          | :btc_test
          | :eth
          | :eth_ropsten
          | :eth_rinkeby
          | :eth_goerli
          | :eth_kovan

  # ----------------------------------------------------------------------------
  # Public API
  # ----------------------------------------------------------------------------

  @doc """
  Format an a username string into a PayID account name
  """
  @spec format(String.t()) :: String.t()
  def format(name) do
    String.replace(
      name,
      @invalidChars,
      fn _ -> "_" end
    ) <> "$" <> domain()
  end

  @doc """
  Get the domain name for the payid server I am using
  """
  @spec domain() :: String.t()
  def domain(), do: @domain

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
  @spec lookup(String.t(), chainT()) ::
          {:ok, map} | {:error, String.t()} | {:error, :invalid_format}
  def lookup(payID, type \\ :xrp_test) do
    accountInfo = String.split(payID, "$")

    case accountInfo do
      [name, server] ->
        {:ok, rsp} =
          Tesla.get("#{@http}://#{server}:8080/#{name}",
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

  @spec lookupAddress(String.t(), chainT()) ::
          {:ok, String.t()} | {:error, String.t()} | {:error, :invalid_format}
  def lookupAddress(payID, type \\ :xrp_test) do
    accountInfo = String.split(payID, "$")

    case accountInfo do
      [name, server] ->
        {:ok, rsp} =
          Tesla.get("#{@http}://#{server}:8080/#{name}",
            headers: [{"Accept", header(type)}, {"PayID-Version", "1.0"}]
          )

        case rsp.status do
          200 ->
            body = Jason.decode!(rsp.body)
            addresses = List.first(body["addresses"])
            Logger.debug("*** body = #{inspect(body, pretty: true)}")
            {:ok, addresses["addressDetails"]["address"]}

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
  Create a new record on the PayID server.

  Arguments:
  payID:  String in the form of <username>$<server address>
  addresses:  Array of tuples with the first element is a string address
              and the second element is the atom code for the network name
  """
  @spec create(String.t(), {String.t(), chainT()}) ::
          :ok | {:error, :bad_request | :in_use | :not_found | :server_unavailable}
  def create(payID, addresses) do
    addrs =
      Enum.map(addresses, fn data ->
        addressBlock(data)
      end)

    data = %{
      payId: payID,
      addresses: addrs
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
  Creates a new PayID account on the interal server

  Arguments:
  payID:  String in the form of <username>$<server address>
  """
  @spec create(String.t(), String.t(), chainT()) ::
          :ok | {:error, :bad_request | :in_use | :server_unavailable}
  def create(payID, address, type) do
    create(payID, {address, type})
  end

  @doc """
  Does a hard set on the addresses assigned to the given account

  Arguments:
  payID:  String in the form of <username>$<server address>
  addresses:  Array of tuples with the first element is a string address
              and the second element is the atom code for the network name
  """
  @spec set(String.t(), [{String.t(), chainT()}]) ::
          :ok | {:error, :bad_request | :in_use | :not_found | :server_unavailable}
  def set(payID, addresses) do
    addrs =
      Enum.map(addresses, fn data ->
        addressBlock(data)
      end)

    data = %{
      payId: payID,
      addresses: addrs
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
  Does a hard set on the addresses assigned to the given account

  Arguments:
  payID:    String in the form of <username>$<server address>
  address:  Crypto address to assign to this account
  type:     Network that this address is on (:eth, :xrp, etc)
  """
  @spec set(String.t(), String.t(), chainT()) ::
          :ok | {:error, :bad_request | :in_use | :server_unavailable}
  def set(payID, address, type) do
    set(payID, [{address, type}])
  end

  @doc """
  Adds additional payment types assigned to a given address
  This is an append operation

  Arguments:
  payID:  String in the form of <username>$<server address>
  addresses:  Array of tuples with the first element is a string address
              and the second element is the atom code for the network name
  """
  @spec append(String.t(), [{String.t(), chainT()}]) ::
          :ok | {:error, :bad_request | :in_use | :not_found | :server_unavailable}
  def append(payID, addresses) do
    {:ok, info} = lookupFull(payID)

    addrs =
      processRsp(info["addresses"], []) ++
        Enum.map(addresses, fn data ->
          addressBlock(data)
        end)

    data = %{
      payId: payID,
      addresses: addrs
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
  Adds additional payment types assigned to a given address
  This is an append operation

  Arguments:
  payID:    String in the form of <username>$<server address>
  address:  Crypto address to assign to this account
  type:     Network that this address is on (:eth, :xrp, etc)
  """
  @spec append(String.t(), String.t(), chainT()) ::
          :ok | {:error, :bad_request | :in_use | :not_found | :server_unavailable}
  def append(payID, address, type), do: append(payID, [{address, type}])

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
  defp network(:eth), do: "ETH"
  defp network(:eth_ropsten), do: "ETH"
  defp network(:eth_rinkeby), do: "ETH"
  defp network(:eth_goerli), do: "ETH"
  defp network(:eth_kovan), do: "ETH"

  defp environment(:xrp_test), do: "TESTNET"

  defp environment(:eth), do: "MAINNET"
  defp environment(:eth_ropsten), do: "ROPSTEN"
  defp environment(:eth_rinkeby), do: "RINKEBY"
  defp environment(:eth_goerli), do: "GOERLI"
  defp environment(:eth_kovan), do: "KOVAN"

  defp addressBlock({address, type}) do
    %{
      paymentNetwork: network(type),
      environment: environment(type),
      details: %{
        address: address
      }
    }
  end

  defp processRsp([], rsp), do: rsp

  defp processRsp([entry | rest], rsp) do
    data = %{
      paymentNetwork: entry["paymentNetwork"],
      environment: entry["environment"],
      details: %{
        address: entry["details"]["address"]
      }
    }

    processRsp(rest, [data | rsp])
  end
end
