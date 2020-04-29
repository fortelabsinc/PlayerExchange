defmodule Gateway.Router.Node.V1.Receiver do
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
    send_resp(conn, 200, Gateway.Router.Node.Handler.ping())
  end

  get "/healthy" do
    if Gateway.Router.Node.Handler.healthy() do
      send_resp(conn, 200, "Application is healthy")
    else
      send_resp(conn, 500, "Application set as unhealthy")
    end
  end

  get "/ready" do
    if Gateway.Router.Node.Handler.ready() do
      send_resp(conn, 200, "Application is ready")
    else
      send_resp(conn, 500, "Application is not ready")
    end
  end

  get "/unhealthy" do
    _ = Gateway.Router.Node.Handler.setHealthyState(false)
    send_resp(conn, 200, "Application is now unhealthy")
  end

  match _ do
    Logger.error("[Gateway.Router.Node.V1.Receiver] Unknown Request: #{inspect(conn)}")

    send_resp(conn, 404, "Invalid Player Exchange Route")
  end
end
