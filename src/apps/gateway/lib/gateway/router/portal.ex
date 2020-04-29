defmodule Gateway.Router.Portal do
  require Logger
  use Plug.Router

  plug(Plug.Logger)
  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  # route all client file requests directly for a specific version.  This
  # way I can host multiple versions of the client if I like.
  forward("/portal/client/v1", to: Gateway.Router.Portal.Client.V1.Receiver)

  # route all
  forward("/portal/commands/v1/auth", to: Gateway.Router.Portal.Commands.V1.Receiver.Auth)

  # For in routing, lets just push everything that comes in from the root to the client.
  forward("/", to: Gateway.Router.Portal.Client.V1.Receiver)
end
