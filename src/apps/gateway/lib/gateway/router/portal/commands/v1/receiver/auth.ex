defmodule Gateway.Router.Portal.Commands.V1.Receiver.Auth do
  @moduledoc """
  """
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

  get "/ping" do
    send_resp(conn, 200, Gateway.Router.Portal.Commands.Handler.Auth.ping())
  end

  match _ do
    Logger.error(
      "[Gateway.Router.Portal.Commands.V1.Receiver.Auth] Unknown Request: #{inspect(conn)}"
    )

    send_resp(conn, 404, "Invalid Player Exchange Route")
  end
end
