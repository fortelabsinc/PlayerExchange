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
defmodule Gateway.Router.Portal.Commands.V1.Receiver.Wallet do
  @moduledoc ~S"""
  Processes the HTTP based requests and sends them to the correct handler.

  The handler or business logic is broken out of http request so I can
  change API versions later on but still keep backwards compatability
  support if possible
  """

  import Utils.Build
  require Logger
  use Plug.Router
  import Plug.Conn

  # ----------------------------------------------------------------------------
  # Plug options
  # ----------------------------------------------------------------------------
  plug(Plug.Logger)

  if_not_prod do
    plug(Corsica, origins: "*", allow_methods: :all, allow_headers: :all)
  end

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  # ----------------------------------------------------------------------------
  # Public Auth APIs
  # ----------------------------------------------------------------------------

  # ----------------------------------------------------------------------------
  # Ping Route Test
  get "/ping" do
    send_resp(conn, 200, "pong")
  end

  # ----------------------------------------------------------------------------
  # Pull all the postings from the system
  get "/balance" do
    case getHeaderValue(conn, "access-token") do
      nil ->
        send_resp(conn, 422, "Missing request parameters: access-token")

      token ->
        case Auth.check(token) do
          {:ok, info} ->
            case Gateway.Router.Portal.Commands.Handler.Wallet.balances(info.username) do
              {:ok, data} ->
                jsonRsp(conn, 200, %{ok: data})

              {:error, msg} ->
                jsonRsp(conn, 500, %{error: msg})
            end

          {:error, errorMessage} ->
            Logger.error("Error getting balance #{inspect(errorMessage)}")
            jsonRsp(conn, 401, %{error: "unauthorized"})
        end
    end
  end

  # ----------------------------------------------------------------------------
  # Temp Routes for Demo
  post "/payment" do
    case getHeaderValue(conn, "access-token") do
      nil ->
        send_resp(conn, 422, "Missing request parameters: access-token")

      token ->
        case conn.body_params do
          nil ->
            send_resp(conn, 422, "Missing boday parameters")

          params ->
            case Auth.check(token) do
              {:ok, info} ->
                {:ok, _} =
                  Gateway.Router.Portal.Commands.Handler.Wallet.payment(
                    params["amt"],
                    params["type"],
                    info.username,
                    params["pay_id"]
                  )

                jsonRsp(conn, 200, %{ok: "ok"})

              {:error, errorMessage} ->
                Logger.error("Error Checking Token #{inspect(errorMessage)}")
                jsonRsp(conn, 401, %{error: "unauthorized"})
            end
        end
    end
  end

  get "/posting/payconfirm/:postId/:username/:payId" do
    case Gateway.Router.Portal.Commands.Handler.Wallet.payPostingConfirm(postId, username, payId) do
      {:ok, _info} ->
        jsonRsp(conn, 200, %{ok: "ok"})

      {:error, errorMessage} ->
        jsonRsp(conn, 401, %{error: errorMessage})
    end
  end

  get "/posting/paycomplete/:postId/:username/:payId" do
    case Gateway.Router.Portal.Commands.Handler.Wallet.payPostingConfirm(postId, username, payId) do
      {:ok, _info} ->
        jsonRsp(conn, 200, %{ok: "ok"})

      {:error, errorMessage} ->
        jsonRsp(conn, 401, %{error: errorMessage})
    end
  end

  get "/posting/paybonus/:postId/:username/:payId" do
    case Gateway.Router.Portal.Commands.Handler.Wallet.payPostingConfirm(postId, username, payId) do
      {:ok, _info} ->
        jsonRsp(conn, 200, %{ok: "ok"})

      {:error, errorMessage} ->
        jsonRsp(conn, 401, %{error: errorMessage})
    end
  end

  # ----------------------------------------------------------------------------
  # Fallback
  match _ do
    Logger.error(
      "[Gateway.Router.Portal.Commands.V1.Receiver.Wallet] Unknown Request: #{
        inspect(conn.body_params)
      }"
    )

    send_resp(conn, 404, "Invalid Forte Route")
  end

  # ----------------------------------------------------------------------------
  # Private API
  # ----------------------------------------------------------------------------
  defp jsonRsp(conn, status, obj) do
    put_resp_content_type(conn, "application/json")
    |> send_resp(status, Jason.encode!(obj))
    |> halt()
  end

  defp getHeaderValue(conn, val) do
    case conn |> get_req_header(val) do
      [val] -> val
      _ -> nil
    end
  end
end
