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
defmodule Gateway.Router.Portal.Commands.V1.Receiver.Guild do
  @moduledoc """

  Process incoming HTTP requests for the main service.  This module could be
  refactored in the future
  """
  import Utils.Build
  require Logger
  use Plug.Router

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
  # Public Node APIs
  # ----------------------------------------------------------------------------

  get "/ping" do
    send_resp(conn, 200, Gateway.Router.Portal.Commands.Handler.Guild.ping())
  end

  # Pull all the games from the system
  get "/" do
    case getHeaderValue(conn, "access-token") do
      nil ->
        send_resp(conn, 422, "Missing request parameters: access-token")

      token ->
        case Auth.check(token) do
          {:ok, _data} ->
            {:ok, data} = Gateway.Router.Portal.Commands.Handler.Guild.all()
            jsonRsp(conn, 200, %{ok: data})

          {:error, errorMessage} ->
            Logger.error("Error Checking Token #{inspect(errorMessage)}")
            jsonRsp(conn, 401, %{error: "unauthorized"})
        end
    end
  end

  # Pull the games based on a page set of info
  get "/page/:page/:count" do
    case getHeaderValue(conn, "access-token") do
      nil ->
        send_resp(conn, 422, "Missing request parameters: access-token")

      token ->
        case Auth.check(token) do
          {:ok, _data} ->
            page = String.to_integer(page)
            count = String.to_integer(count)
            {:ok, data} = Gateway.Router.Portal.Commands.Handler.Guild.page(page, count)
            jsonRsp(conn, 200, %{ok: data})

          {:error, errorMessage} ->
            Logger.error("Error Checking Token #{inspect(errorMessage)}")
            jsonRsp(conn, 401, %{error: "unauthorized"})
        end
    end
  end

  get "/names" do
    case getHeaderValue(conn, "access-token") do
      nil ->
        send_resp(conn, 422, "Missing request parameters: access-token")

      token ->
        case Auth.check(token) do
          {:ok, _data} ->
            case Gateway.Router.Portal.Commands.Handler.Guild.names() do
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

  get "/:guildId" do
    case getHeaderValue(conn, "access-token") do
      nil ->
        send_resp(conn, 422, "Missing request parameters: access-token")

      token ->
        case Auth.check(token) do
          {:ok, _data} ->
            case Gateway.Router.Portal.Commands.Handler.Guild.info(guildId) do
              {:ok, data} ->
                jsonRsp(conn, 200, %{ok: data})

              {:error, msg} ->
                jsonRsp(conn, 404, %{error: msg})
            end

          {:error, errorMessage} ->
            Logger.error("Error Checking Token #{inspect(errorMessage)}")
            jsonRsp(conn, 401, %{error: "unauthorized"})
        end
    end
  end

  get "/:guildId/balance" do
    case getHeaderValue(conn, "access-token") do
      nil ->
        send_resp(conn, 422, "Missing request parameters: access-token")

      token ->
        case Auth.check(token) do
          {:ok, data} ->
            userId = data.user_id

            case Gateway.Router.Portal.Commands.Handler.Guild.balance(guildId, userId) do
              {:ok, data} ->
                jsonRsp(conn, 200, %{ok: data})

              {:error, msg} ->
                jsonRsp(conn, 404, %{error: msg})
            end

          {:error, errorMessage} ->
            Logger.error("Error Checking Token #{inspect(errorMessage)}")
            jsonRsp(conn, 401, %{error: "unauthorized"})
        end
    end
  end

  delete "/:guildId" do
    case getHeaderValue(conn, "access-token") do
      nil ->
        send_resp(conn, 422, "Missing request parameters: access-token")

      token ->
        case Auth.check(token) do
          {:ok, data} ->
            userId = data.user_id
            :ok = Gateway.Router.Portal.Commands.Handler.Guild.delete(guildId, userId)
            jsonRsp(conn, 200, %{ok: "ok"})

          {:error, errorMessage} ->
            Logger.error("Error Checking Token #{inspect(errorMessage)}")
            jsonRsp(conn, 401, %{error: "unauthorized"})
        end
    end
  end

  # Post request to create a new app.  Need an auth handling service
  post "/" do
    case conn.body_params do
      nil ->
        jsonRsp(conn, 422, %{error: "Missing boday parameters"})

      params ->
        case getHeaderValue(conn, "access-token") do
          nil ->
            send_resp(conn, 422, "Missing request parameters: access-token")

          token ->
            case Auth.check(token) do
              {:ok, data} ->
                owner = data.user_id
                # Break out the needed fields for the handler
                name = Map.get(params, "name")
                # Need to pull out the current session user ID
                image = Map.get(params, "image")

                description = Map.get(params, "description")

                case Gateway.Router.Portal.Commands.Handler.Guild.create(
                       name,
                       owner,
                       image,
                       description
                     ) do
                  {:ok, info} ->
                    jsonRsp(conn, 201, %{ok: info})

                  {:error, errorMessage} ->
                    Logger.error(
                      "[Gateway.Router.Service.V1.Receiver] Error Create Game #{
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

                case Gateway.Router.Portal.Commands.Handler.Guild.names(ids) do
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

  post "/:guildId/name" do
    case conn.body_params do
      nil ->
        send_resp(conn, 422, "Missing boday parameters")

      params ->
        case getHeaderValue(conn, "access-token") do
          nil ->
            send_resp(conn, 422, "Missing request parameters: access-token")

          token ->
            case Auth.check(token) do
              {:ok, data} ->
                userId = data.user_id
                name = Map.get(params, "name")

                case Gateway.Router.Portal.Commands.Handler.Guild.updateName(
                       guildId,
                       userId,
                       name
                     ) do
                  :ok ->
                    jsonRsp(conn, 200, %{ok: "ok"})

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

  post "/:guildId/owner" do
    case conn.body_params do
      nil ->
        send_resp(conn, 422, "Missing boday parameters")

      params ->
        case getHeaderValue(conn, "access-token") do
          nil ->
            send_resp(conn, 422, "Missing request parameters: access-token")

          token ->
            case Auth.check(token) do
              {:ok, data} ->
                userId = data.user_id
                owner = Map.get(params, "user_id")

                case Gateway.Router.Portal.Commands.Handler.Guild.updateOwner(
                       guildId,
                       userId,
                       owner
                     ) do
                  :ok ->
                    jsonRsp(conn, 200, %{ok: "ok"})

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

  post "/:guildId/image" do
    case conn.body_params do
      nil ->
        send_resp(conn, 422, "Missing boday parameters")

      params ->
        case getHeaderValue(conn, "access-token") do
          nil ->
            send_resp(conn, 422, "Missing request parameters: access-token")

          token ->
            case Auth.check(token) do
              {:ok, data} ->
                userId = data.user_id
                image = Map.get(params, "image")

                case Gateway.Router.Portal.Commands.Handler.Guild.updateImage(
                       guildId,
                       userId,
                       image
                     ) do
                  :ok ->
                    jsonRsp(conn, 200, %{ok: "ok"})

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

  post "/:guildId/meta" do
    case conn.body_params do
      nil ->
        send_resp(conn, 422, "Missing boday parameters")

      params ->
        case getHeaderValue(conn, "access-token") do
          nil ->
            send_resp(conn, 422, "Missing request parameters: access-token")

          token ->
            case Auth.check(token) do
              {:ok, data} ->
                userId = data.user_id
                meta = Map.get(params, "meta")

                case Gateway.Router.Portal.Commands.Handler.Guild.updateMeta(
                       guildId,
                       userId,
                       meta
                     ) do
                  :ok ->
                    jsonRsp(conn, 200, %{ok: "ok"})

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

  put "/:guildId/user/:userId" do
    case getHeaderValue(conn, "access-token") do
      nil ->
        send_resp(conn, 422, "Missing request parameters: access-token")

      token ->
        case Auth.check(token) do
          {:ok, data} ->
            ownerId = data.user_id

            case Gateway.Router.Portal.Commands.Handler.Guild.addUser(
                   guildId,
                   ownerId,
                   userId
                 ) do
              :ok ->
                jsonRsp(conn, 200, %{ok: "ok"})

              {:ok, _} ->
                jsonRsp(conn, 200, %{ok: "ok"})

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

  put "/:guildId/user/:userId/:stake" do
    case getHeaderValue(conn, "access-token") do
      nil ->
        send_resp(conn, 422, "Missing request parameters: access-token")

      token ->
        case Auth.check(token) do
          {:ok, data} ->
            ownerId = data.user_id
            stake = String.to_integer(stake)

            case Gateway.Router.Portal.Commands.Handler.Guild.updateUserStake(
                   guildId,
                   ownerId,
                   userId,
                   stake
                 ) do
              :ok ->
                jsonRsp(conn, 200, %{ok: "ok"})

              {:ok, _} ->
                jsonRsp(conn, 200, %{ok: "ok"})

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

  delete "/:guildId/user/:userId" do
    case getHeaderValue(conn, "access-token") do
      nil ->
        send_resp(conn, 422, "Missing request parameters: access-token")

      token ->
        case Auth.check(token) do
          {:ok, data} ->
            ownerId = data.user_id

            case Gateway.Router.Portal.Commands.Handler.Guild.removeUser(
                   guildId,
                   ownerId,
                   userId
                 ) do
              :ok ->
                jsonRsp(conn, 200, %{ok: "ok"})

              {:ok, _} ->
                jsonRsp(conn, 200, %{ok: "ok"})

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

  put "/:guildId/game/:gameId" do
    case getHeaderValue(conn, "access-token") do
      nil ->
        send_resp(conn, 422, "Missing request parameters: access-token")

      token ->
        case Auth.check(token) do
          {:ok, data} ->
            ownerId = data.user_id

            case Gateway.Router.Portal.Commands.Handler.Guild.addGame(
                   guildId,
                   ownerId,
                   gameId
                 ) do
              :ok ->
                jsonRsp(conn, 200, %{ok: "ok"})

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

  delete "/:guildId/game/:gameId" do
    case getHeaderValue(conn, "access-token") do
      nil ->
        send_resp(conn, 422, "Missing request parameters: access-token")

      token ->
        case Auth.check(token) do
          {:ok, data} ->
            ownerId = data.user_id

            case Gateway.Router.Portal.Commands.Handler.Guild.removeGame(
                   guildId,
                   ownerId,
                   gameId
                 ) do
              :ok ->
                jsonRsp(conn, 200, %{ok: "ok"})

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

  post "/:guildId/pay" do
    case conn.body_params do
      nil ->
        send_resp(conn, 422, "Missing boday parameters")

      params ->
        case getHeaderValue(conn, "access-token") do
          nil ->
            send_resp(conn, 422, "Missing request parameters: access-token")

          token ->
            case Auth.check(token) do
              {:ok, data} ->
                userId = data.user_id
                amount = Map.get(params, "amount")
                type = Map.get(params, "type")

                case Gateway.Router.Portal.Commands.Handler.Guild.pay(
                       guildId,
                       userId,
                       type,
                       amount
                     ) do
                  :ok ->
                    jsonRsp(conn, 200, %{ok: "ok"})

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

  match _ do
    Logger.error(
      "[Gateway.Router.Service.V1.Receiver] Unknown Request: #{inspect(conn.request_path)}"
    )

    send_resp(conn, 404, "Invalid PPS Route")
  end

  # ----------------------------------------------------------------------------
  # Private API
  # ---------------------------------------------------------------------------

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
