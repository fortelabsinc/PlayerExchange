defmodule Gateway.Router.Portal do
  require Logger
  use Plug.Router

  plug(Plug.Logger)
  plug(:redirect_index)
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
  forward("/portal/commands/v1/auth/", to: Gateway.Router.Portal.Commands.V1.Receiver.Auth)

  # For in routing, lets just push everything that comes in from the root to the client.
  # forward("/", to: Gateway.Router.Portal.Client.V1.Receiver)
  @spec redirect_index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def redirect_index(%Plug.Conn{path_info: path} = conn, _opts) do
    case path do
      [] ->
        %{conn | path_info: ["portal", "client", "v1", "index.html"]}

      ["portal"] ->
        %{conn | path_info: path ++ ["client", "v1", "index.html"]}

      ["portal", "client"] ->
        %{conn | path_info: path ++ ["v1", "index.html"]}

      ["portal", "client", "v1"] ->
        %{conn | path_info: path ++ ["index.html"]}

      _ ->
        conn

        # _ ->
        #  Logger.info("#{inspect(path)}")
        #  %{conn | path_info: ["portal" | ["client" | ["v1" | path]]]}
    end
  end
end
