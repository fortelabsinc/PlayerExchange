defmodule Gateway.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = enableNodeRouter([])
    # Setup any state needed for the Node Router
    Gateway.Router.Node.Handler.init()
    opts = [strategy: :one_for_one, name: Gateway.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp enableNodeRouter(children) do
    httpType =
      if String.to_existing_atom(System.get_env("PLYXCHG_GATEWAY_NODE_TLS", "false")) do
        :https
      else
        if Application.get_env(:gateway, :node_enable_tls, false) do
          :https
        else
          :http
        end
      end

    [
      Plug.Cowboy.child_spec(
        scheme: httpType,
        plug: Gateway.Router.Node,
        port:
          String.to_integer(
            System.get_env(
              "PLYXCHG_GATEWAY_NODE_PORT",
              Application.get_env(:gateway, :node_port, "8180")
            )
          )
      )
      | children
    ]
  end
end
