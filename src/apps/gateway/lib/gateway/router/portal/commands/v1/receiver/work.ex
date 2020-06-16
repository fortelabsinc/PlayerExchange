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
defmodule Gateway.Router.Portal.Commands.V1.Receiver.Work do
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
  get "/posting" do
    case getHeaderValue(conn, "access-token") do
      nil ->
        send_resp(conn, 422, "Missing request parameters: access-token")

      token ->
        case Auth.check(token) do
          {:ok, _meta} ->
            postings = Gateway.Router.Portal.Commands.Handler.Work.postings()
            jsonRsp(conn, 200, %{ok: postings})

          {:error, errorMessage} ->
            Logger.error("Error Checking Token #{inspect(errorMessage)}")
            jsonRsp(conn, 401, %{error: "unauthorized"})
        end
    end
  end

  # ----------------------------------------------------------------------------
  # Get all the postings for a specific user
  get "/posting/:user_id" do
    case getHeaderValue(conn, "access-token") do
      nil ->
        send_resp(conn, 422, "Missing request parameters: access-token")

      token ->
        case Auth.check(token) do
          {:ok, _info} ->
            postings = Gateway.Router.Portal.Commands.Handler.Work.postings(user_id)
            jsonRsp(conn, 200, %{ok: postings})

          {:error, errorMessage} ->
            Logger.error("Error Checking Token #{inspect(errorMessage)}")
            jsonRsp(conn, 401, %{error: "unauthorized"})
        end
    end
  end

  # ----------------------------------------------------------------------------
  # Delete a specific posting.  It is assumed that the user who matches the
  # token owns it
  delete "/posting/:posting_id" do
    case getHeaderValue(conn, "access-token") do
      nil ->
        send_resp(conn, 422, "Missing request parameters: access-token")

      token ->
        case Auth.check(token) do
          {:ok, info} ->
            postings =
              Gateway.Router.Portal.Commands.Handler.Work.deletePosting(info.username, posting_id)

            jsonRsp(conn, 200, %{ok: postings})

          {:error, errorMessage} ->
            Logger.error("Error Checking Token #{inspect(errorMessage)}")
            jsonRsp(conn, 401, %{error: "unauthorized"})
        end
    end
  end

  # ----------------------------------------------------------------------------
  # Delete all postings ownd by this user
  delete "/posting" do
    case getHeaderValue(conn, "access-token") do
      nil ->
        send_resp(conn, 422, "Missing request parameters: access-token")

      token ->
        case Auth.check(token) do
          {:ok, info} ->
            postings = Gateway.Router.Portal.Commands.Handler.Work.deletePosting(info.username)
            jsonRsp(conn, 200, %{ok: postings})

          {:error, errorMessage} ->
            Logger.error("Error Checking Token #{inspect(errorMessage)}")
            jsonRsp(conn, 401, %{error: "unauthorized"})
        end
    end
  end

  # ----------------------------------------------------------------------------
  # Create a new posting
  post "/posting" do
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
                  Gateway.Router.Portal.Commands.Handler.Work.addPosting(info.username, params)

                jsonRsp(conn, 200, %{ok: "ok"})

              {:error, errorMessage} ->
                Logger.error("Error Checking Token #{inspect(errorMessage)}")
                jsonRsp(conn, 401, %{error: "unauthorized"})
            end
        end
    end
  end

  # ----------------------------------------------------------------------------
  # Fallback
  match _ do
    Logger.error(
      "[Gateway.Router.Portal.Commands.V1.Receiver.Work] Unknown Request: #{
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
