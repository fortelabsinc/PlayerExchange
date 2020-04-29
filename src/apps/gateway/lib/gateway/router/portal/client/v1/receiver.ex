defmodule Gateway.Router.Portal.Client.V1.Receiver do
  require Logger
  use Plug.Builder

  plug(Plug.Static,
    at: "/",
    from: {:gateway, "priv/static/client/v1"}
  )

  plug(:not_found)

  @doc """
  Can't found the resource.  Let's log this so we know what folks are doing
  """
  @spec not_found(Plug.Conn.t(), any) :: Plug.Conn.t()
  def not_found(conn, _) do
    Logger.error("Gateway.Router.Portal.Client.V1.Receiver: Path not found #{inspect(conn)}")
    send_resp(conn, 404, "not found")
  end
end
