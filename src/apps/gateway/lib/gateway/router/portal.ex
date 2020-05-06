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
defmodule Gateway.Router.Portal do
  @moduledoc ~S"""
  Define the routes for the Portal endpoints

  All the routes are to be called by the endpoints
  """

  require Logger
  use Plug.Router

  # ----------------------------------------------------------------------------
  # Plug options
  # ----------------------------------------------------------------------------
  plug(Plug.Logger)
  plug(:redirect_index)
  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  # ----------------------------------------------------------------------------
  # Forward routes
  # ----------------------------------------------------------------------------

  # route all client file requests directly for a specific version.  This
  # way I can host multiple versions of the client if I like.
  forward("/portal/client/v1", to: Gateway.Router.Portal.Client.V1.Receiver)

  # route all auth to the receiver
  forward("/portal/commands/v1/auth/", to: Gateway.Router.Portal.Commands.V1.Receiver.Auth)

  # route all work to the receiver
  forward("/portal/commands/v1/work/", to: Gateway.Router.Portal.Commands.V1.Receiver.Work)

  # route all profile to the receiver
  forward("/portal/commands/v1/profile/", to: Gateway.Router.Portal.Commands.V1.Receiver.Profile)

  # route all wallet to the receiver
  forward("/portal/commands/v1/wallet/", to: Gateway.Router.Portal.Commands.V1.Receiver.Wallet)

  # ----------------------------------------------------------------------------
  # Public API
  # ----------------------------------------------------------------------------

  @doc """
  For in routing, lets just push everything that comes in from the root to the client.
  forward("/", to: Gateway.Router.Portal.Client.V1.Receiver)
  """
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
