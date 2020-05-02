defmodule Blockchain.Ripple.PayID do
  @moduledoc """
  """
  require Logger
  import Utils.Build

  # In production builds we will look to kubernetes
  # DNS services to find the service.  Otherwise
  # just assume it is on local host and move forward
  if_prod do
    @serverName "http://payid.default.svc.cluster.local:8081"
  else
    @serverName "http://localhost:8081"
  end

  @middleware [
    {Tesla.Middleware.BaseUrl, @serverName},
    Tesla.Middleware.JSON
  ]

  @doc """
  Lookup a PayID user.  The format returned will be
  {:ok, %{
    "addressDetailType" => "CryptoAddressDetails",
    "addressDetails" => %{
      "address" => "address"
    }
  }}
  """
  def lookup(payID, type \\ :xrp_test) do
    accountInfo = String.split(payID, "$")

    case accountInfo do
      [name, server] ->
        {:ok, rsp} =
          Tesla.get("https://#{server}/#{name}",
            headers: [{"Accept", header(type)}]
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

  def lookupFull(client, payID) do
    {:ok, rsp} = Tesla.get(client, "/v1/users/#{payID}")

    case rsp.status do
      200 -> {:ok, rsp.body}
      400 -> {:error, :bad_request}
      404 -> {:error, :not_found}
      503 -> {:error, :server_unavailable}
    end
  end

  def create(client, payID, wallet, :xrp_test) do
    data = """
    {
      "pay_id": "#{payID}"",
      "addresses": [
        "payment_network": "XRPL",
        "environment": "TESTNET",
        "details": {
            "address": "#{wallet}"
        }
      ]
    }
    """

    {:ok, rsp} =
      Tesla.post(client, "/v1/users", data, headers: [{"Content-Type", "application/json"}])

    case rsp.status do
      201 -> :ok
      400 -> {:error, :bad_request}
      409 -> {:error, :in_use}
      503 -> {:error, :server_unavailable}
    end
  end

  def update(client, payID, wallet, :xrp_test) do
    data = """
    {
      "pay_id": "#{payID}"",
      "addresses": [
        "payment_network": "XRPL",
        "environment": "TESTNET",
        "details": {
            "address": "#{wallet}"
        }
      ]
    }
    """

    {:ok, rsp} =
      Tesla.put(client, "/v1/users/#{payID}", data,
        headers: [{"Content-Type", "application/json"}]
      )

    case rsp.status do
      200 -> :ok
      400 -> {:error, :bad_request}
      409 -> {:error, :in_use}
      503 -> {:error, :server_unavailable}
    end
  end

  def delete(client, payID) do
    {:ok, rsp} = Tesla.delete(client, "/v1/users/#{payID}/")

    case rsp.status do
      200 -> :ok
      400 -> {:error, :bad_request}
      404 -> {:error, :not_found}
      503 -> {:error, :server_unavailable}
    end
  end

  def client(), do: Tesla.client(@middleware)

  # Pull out the header address for the network you are looking for
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
end
