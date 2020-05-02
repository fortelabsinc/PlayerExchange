defmodule Blockchain.Ripple.XRP do
  require Logger
  import Utils.Build

  if_prod do
    @serverName "http://rippler.default.svc.cluster.local:3000"
  else
    @serverName "http://localhost:3000"
  end

  @middleware [
    {Tesla.Middleware.BaseUrl, @serverName},
    Tesla.Middleware.JSON
  ]

  def health(client \\ client()) do
    case Tesla.get(client, "/node/healthy") do
      {:ok, rsp} ->
        Logger.info("I got the helath status")
        {:ok, rsp.body}

      rsp ->
        rsp
    end
  end

  def balance(address), do: balance(client(), address)

  def balance(client, address) do
    case Tesla.get(client, "/wallet/balance/#{address}") do
      {:ok, rsp} ->
        {:ok, rsp.body}

      rsp ->
        rsp
    end
  end

  def history(address), do: history(client(), address)

  def history(client, address) do
    case Tesla.get(client, "/wallet/history/#{address}") do
      {:ok, rsp} ->
        {:ok, rsp.body}

      rsp ->
        rsp
    end
  end

  def status(address), do: status(client(), address)

  def status(client, hash) do
    case Tesla.get(client, "/wallet/status/#{hash}") do
      {:ok, rsp} ->
        {:ok, rsp.body}

      rsp ->
        rsp
    end
  end

  def create(client \\ client()) do
    case Tesla.post(client, "/wallet/create", "") do
      {:ok, rsp} ->
        {:ok, rsp.body}

      rsp ->
        rsp
    end
  end

  def pay(client \\ client(), amount, from_mnemonic, to) do
    data = """
    {
      "amount": "#{amount}",
      "type": "mnemonic",
      "from": "#{from_mnemonic}",
      "to": "#{to}"
    }
    """

    case Tesla.post(client, "/wallet/create", data) do
      {:ok, rsp} ->
        {:ok, rsp.body}

      rsp ->
        rsp
    end
  end

  def client(), do: Tesla.client(@middleware)
end
