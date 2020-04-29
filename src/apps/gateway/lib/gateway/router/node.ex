defmodule Gateway.Router.Node do
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

  forward("/node/v1", to: Gateway.Router.Node.V1.Receiver)

  match _ do
    Logger.error("[Gateway.Router.Node] Unknown Request: #{inspect(conn.body_params)}")
    send_resp(conn, 404, "Invalid Player Exchange Route")
  end
end
