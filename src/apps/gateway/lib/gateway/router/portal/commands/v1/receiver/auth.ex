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
defmodule Gateway.Router.Portal.Commands.V1.Receiver.Auth do
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
  # This is a basic lookup for an access-token to get the user info
  get "/check" do
    case getHeaderValue(conn, "access-token") do
      nil ->
        send_resp(conn, 422, "Missing request parameters: access-token")

      token ->
        case Gateway.Router.Portal.Commands.Handler.Auth.check(token) do
          {:ok, meta} ->
            jsonRsp(conn, 200, %{ok: meta})

          {:error, errorMessage} ->
            Logger.error("Error Checking Token #{inspect(errorMessage)}")
            jsonRsp(conn, 401, %{error: "unauthorized"})
        end
    end
  end

  # ----------------------------------------------------------------------------
  # Referesh a token that already exists
  get "/refresh" do
    case getHeaderValue(conn, "refresh-token") do
      nil ->
        send_resp(conn, 422, "Missing request parameters: refresh-token")

      token ->
        case Gateway.Router.Portal.Commands.Handler.Auth.refresh(token) do
          {:ok, meta} ->
            jsonRsp(conn, 200, %{ok: meta})

          {:error, errorMessage} ->
            Logger.error("Error Refreshing Token #{inspect(errorMessage)}")
            jsonRsp(conn, 401, %{error: "unauthorized"})
        end
    end
  end

  # ----------------------------------------------------------------------------
  # Register a new user
  post "/register" do
    case conn.body_params do
      nil ->
        send_resp(conn, 422, "Missing boday parameters")

      params ->
        case Gateway.Router.Portal.Commands.Handler.Auth.register(params) do
          {:ok, data} ->
            jsonRsp(conn, 201, %{ok: data})

          {:error, errorMessage} ->
            Logger.error("Error Register user #{inspect(errorMessage)}")
            jsonRsp(conn, 400, %{error: "unauthorized"})
        end
    end
  end

  # ----------------------------------------------------------------------------
  # Confirm a user is on the system?
  get "/confirm" do
    case conn.params do
      nil ->
        send_resp(conn, 422, "Missing boday parameters")

      params ->
        case params["confirm_id"] do
          nil ->
            send_resp(conn, 422, "Missing request parameters: confirm_id")

          id ->
            case Gateway.Router.Portal.Commands.Handler.Auth.confirm(id) do
              {:ok, _data} ->
                msg = """
                <!DOCTYPE html>
                <html>
                  <head>
                      <title>Account Confirmed</title>
                      <meta http-equiv = "refresh" content = "0; url = /portal/client/v1/index.html#/auth/login" />
                  </head>
                  <body>
                      <p>Thank you.  Forwarding you to login.</p>
                  </body>
                </html>
                """

                send_resp(conn, 200, msg)

              {:error, errorMessage} ->
                Logger.error("Error Register user #{inspect(errorMessage)}")
                jsonRsp(conn, 400, %{error: "unauthorized"})
            end
        end
    end
  end

  # ----------------------------------------------------------------------------
  # Confirm a registration
  post "/confirm" do
    case conn.body_params do
      nil ->
        send_resp(conn, 422, "Missing boday parameters")

      params ->
        case params["confirm_id"] do
          nil ->
            send_resp(conn, 422, "Missing request parameters: confirm_id")

          id ->
            case Gateway.Router.Portal.Commands.Handler.Auth.confirm(id) do
              {:ok, data} ->
                jsonRsp(conn, 201, %{ok: data})

              {:error, errorMessage} ->
                Logger.error("Error Register user #{inspect(errorMessage)}")
                jsonRsp(conn, 400, %{error: "unauthorized"})
            end
        end
    end
  end

  # ----------------------------------------------------------------------------
  # Log user in
  post "/login" do
    case conn.body_params do
      nil ->
        send_resp(conn, 422, "Missing boday parameters")

      params ->
        user = params["username"]
        pass = params["password"]

        if nil == user or nil == pass do
          send_resp(conn, 422, "Missing request parameters: username or password")
        else
          case Gateway.Router.Portal.Commands.Handler.Auth.login(user, pass) do
            {:ok, data} ->
              jsonRsp(conn, 200, %{ok: data})

            {:error, errorMessage} ->
              Logger.error("Error loging user in user #{inspect(errorMessage)}")
              jsonRsp(conn, 401, %{error: errorMessage})
          end
        end
    end
  end

  # ----------------------------------------------------------------------------
  # Log the user out
  post "/logout" do
    case getHeaderValue(conn, "access-token") do
      nil ->
        send_resp(conn, 422, "Missing request parameters: access-token")

      token ->
        case Gateway.Router.Portal.Commands.Handler.Auth.logout(token) do
          {:ok, meta} ->
            jsonRsp(conn, 200, %{ok: meta})

          {:error, errorMessage} ->
            Logger.error("Error Logging out user: #{inspect(errorMessage)}")
            jsonRsp(conn, 401, %{error: errorMessage})
        end
    end
  end

  # ----------------------------------------------------------------------------
  # Reset a password
  post "/reset_password" do
    case conn.body_params do
      nil ->
        send_resp(conn, 422, "Missing boday parameters")

      params ->
        user = params["username"]

        if nil == user do
          send_resp(conn, 422, "Missing request parameters: username")
        else
          case Gateway.Router.Portal.Commands.Handler.Auth.resetPassword(user) do
            {:ok, data} ->
              jsonRsp(conn, 201, %{ok: data})

            {:error, _} ->
              jsonRsp(conn, 200, %{ok: "password reset sent to accounts email"})
          end
        end
    end
  end

  # ----------------------------------------------------------------------------
  # Change the password
  post "/change_password" do
    case conn.body_params do
      nil ->
        send_resp(conn, 422, "Missing boday parameters")

      params ->
        id = params["password_id"]
        pass = params["new_password"]
        conf = params["password_confirm"]

        if nil == id or nil == pass or nil == conf do
          send_resp(
            conn,
            422,
            "Missing request parameters: password_id or new_password or password_confirm"
          )
        else
          case Gateway.Router.Portal.Commands.Handler.Auth.changePassword(id, pass, conf) do
            {:ok, data} ->
              jsonRsp(conn, 201, %{ok: data})

            {:error, err} ->
              jsonRsp(conn, 400, %{error: err})
          end
        end
    end
  end

  # ----------------------------------------------------------------------------
  # Forgot the password.  Genreate email
  post "forgot_username" do
    case conn.body_params do
      nil ->
        send_resp(conn, 422, "Missing boday parameters")

      params ->
        email = params["email"]

        if nil == email do
          send_resp(
            conn,
            422,
            "Missing request parameters: email"
          )
        else
          case Gateway.Router.Portal.Commands.Handler.Auth.forgotUsername(email) do
            {:ok, data} ->
              jsonRsp(conn, 200, %{ok: data})

            {:error, _err} ->
              jsonRsp(conn, 200, %{ok: "sent email with related username"})
          end
        end
    end
  end

  post "/names" do
    case conn.body_params do
      nil ->
        send_resp(conn, 422, "Missing boday parameters")

      params ->
        case getHeaderValue(conn, "access-token") do
          nil ->
            send_resp(conn, 422, "Missing request parameters: access-token")

          token ->
            case Auth.check(token) do
              {:ok, _data} ->
                ids = Map.get(params, "ids")

                case Gateway.Router.Portal.Commands.Handler.Auth.names(ids) do
                  {:ok, nameMap} ->
                    jsonRsp(conn, 200, %{ok: nameMap})

                  {:error, errorMessage} ->
                    Logger.error(
                      "[Gateway.Router.Service.V1.Receiver] Error update app email #{
                        inspect(errorMessage)
                      }"
                    )

                    jsonRsp(conn, 500, %{error: errorMessage})
                end

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
      "[Gateway.Router.Portal.Commands.V1.Receiver.Auth] Unknown Request: #{
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
