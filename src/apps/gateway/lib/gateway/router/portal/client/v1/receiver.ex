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
defmodule Gateway.Router.Portal.Client.V1.Receiver do
  @moduledoc ~S"""
  Processes the HTTP based requests and sends them to the correct handler.

  The handler or business logic is broken out of http request so I can
  change API versions later on but still keep backwards compatability
  support if possible
  """

  require Logger
  use Plug.Builder

  # ----------------------------------------------------------------------------
  # Plug options
  # ----------------------------------------------------------------------------
  plug(Plug.Static,
    at: "/portal/client/v1",
    from: {:gateway, "priv/static/client/v1"}
  )

  plug(Plug.Static,
    at: "/portal/client",
    from: {:gateway, "priv/static/client/v1"}
  )

  plug(Plug.Static,
    at: "/portal",
    from: {:gateway, "priv/static/client/v1"}
  )

  plug(Plug.Static,
    at: "/",
    from: {:gateway, "priv/static/client/v1"}
  )

  plug(:not_found)

  # ----------------------------------------------------------------------------
  # Public Auth APIs
  # ----------------------------------------------------------------------------

  @doc """
  Can't found the resource.  Let's log this so we know what folks are doing
  """
  @spec not_found(Plug.Conn.t(), any) :: Plug.Conn.t()
  def not_found(conn, _) do
    Logger.error("Gateway.Router.Portal.Client.V1.Receiver: Path not found #{inspect(conn)}")
    send_resp(conn, 200, "ok")
  end
end
