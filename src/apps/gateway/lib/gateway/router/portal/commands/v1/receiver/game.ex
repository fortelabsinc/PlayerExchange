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
defmodule Gateway.Router.Portal.Commands.V1.Receiver.Game do
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
    send_resp(conn, 200, Gateway.Router.Portal.Commands.Handler.Game.ping())
  end

  #  get "/" do
  #    {:ok, data} = Gateway.Router.Portal.Commands.Handler.App.getApps()
  #    jsonRsp(conn, 200, %{ok: data})
  #  end
  #
  #  get "/page/:page/:count" do
  #    page = String.to_integer(page)
  #    count = String.to_integer(count)
  #    {:ok, data} = Gateway.Router.Portal.Commands.Handler.Game.getAppsPage(page, count)
  #    jsonRsp(conn, 200, %{ok: data})
  #  end
  #
  #  get "/:gameId" do
  #    case Gateway.Router.Portal.Commands.Handler.Game.getApp(appId) do
  #      {:ok, data} ->
  #        jsonRsp(conn, 200, %{ok: data})
  #
  #      {:error, msg} ->
  #        jsonRsp(conn, 404, %{error: msg})
  #    end
  #  end
  #
  #  delete "/:gameId" do
  #    :ok = Gateway.Router.Portal.Commands.Handler.Game.removeApp(appId)
  #    jsonRsp(conn, 200, %{ok: "ok"})
  #  end
  #
  #  # Post request to create a new app.  Need an auth handling service
  #  post "/" do
  #    case conn.body_params do
  #      nil ->
  #        jsonRsp(conn, 422, %{error: "Missing boday parameters"})
  #
  #      params ->
  #        if Gateway.Router.Portal.Commands.V1.Receiver.Schema.validate(:register_app_req, params) do
  #          # Break out the needed fields for the handler
  #          webhook = Map.get(params, "hook")
  #          publicKey = Map.get(params, "key")
  #          name = Map.get(params, "name")
  #          email = Map.get(params, "email")
  #
  #          case Gateway.Router.Portal.Commands.Handler.Game.registerApp(
  #                 name,
  #                 webhook,
  #                 publicKey,
  #                 email
  #               ) do
  #            {:ok, id} ->
  #              jsonRsp(conn, 201, %{ok: %{id: id}})
  #
  #            {:error, errorMessage} ->
  #              Logger.error(
  #                "[Gateway.Router.Service.V1.Receiver] Error Register app #{inspect(errorMessage)}"
  #              )
  #
  #              jsonRsp(conn, 500, %{error: errorMessage})
  #          end
  #        else
  #          Logger.error(
  #            "[Gateway.Router.Service.V1.Receiver] Error Register request schema violation #{
  #              inspect(params)
  #            }"
  #          )
  #
  #          jsonRsp(conn, 500, %{error: "unauthorized"})
  #        end
  #    end
  #  end
  #
  #  post "/:gameId/email" do
  #    case conn.body_params do
  #      nil ->
  #        send_resp(conn, 422, "Missing boday parameters")
  #
  #      params ->
  #        if Gateway.Router.Portal.Commands.V1.Receiver.Schema.validate(:update_app_email, params) do
  #          # Break out the needed fields for the handler
  #          appId = Map.get(params, "id")
  #          email = Map.get(params, "email")
  #
  #          case Gateway.Router.Portal.Commands.Handler.Game.updateAppEmail(appId, email) do
  #            :ok ->
  #              jsonRsp(conn, 200, %{ok: "ok"})
  #
  #            {:error, errorMessage} ->
  #              Logger.error(
  #                "[Gateway.Router.Service.V1.Receiver] Error update app email #{
  #                  inspect(errorMessage)
  #                }"
  #              )
  #
  #              jsonRsp(conn, 500, %{error: errorMessage})
  #          end
  #        else
  #          Logger.error(
  #            "[Gateway.Router.Service.V1.Receiver] Error Update email request schema violation #{
  #              inspect(params)
  #            }"
  #          )
  #
  #          jsonRsp(conn, 500, %{error: "unauthorized"})
  #        end
  #    end
  #  end
  #
  #  post "/:gameId/name" do
  #    case conn.body_params do
  #      nil ->
  #        send_resp(conn, 422, "Missing boday parameters")
  #
  #      params ->
  #        if Gateway.Router.Portal.Commands.V1.Receiver.Schema.validate(:update_app_name, params) do
  #          # Break out the needed fields for the handler
  #          appId = Map.get(params, "id")
  #          email = Map.get(params, "name")
  #
  #          case Gateway.Router.Portal.Commands.Handler.Game.updateAppName(appId, email) do
  #            :ok ->
  #              jsonRsp(conn, 200, %{ok: "ok"})
  #
  #            {:error, errorMessage} ->
  #              Logger.error(
  #                "[Gateway.Router.Service.V1.Receiver] Error update app name #{
  #                  inspect(errorMessage)
  #                }"
  #              )
  #
  #              jsonRsp(conn, 500, %{error: errorMessage})
  #          end
  #        else
  #          Logger.error(
  #            "[Gateway.Router.Service.V1.Receiver] Error Update name request schema violation #{
  #              inspect(params)
  #            }"
  #          )
  #
  #          jsonRsp(conn, 500, %{error: "unauthorized"})
  #        end
  #    end
  #  end
  #
  #  post "/:gameId/key" do
  #    case conn.body_params do
  #      nil ->
  #        send_resp(conn, 422, "Missing boday parameters")
  #
  #      params ->
  #        if Gateway.Router.Portal.Commands.V1.Receiver.Schema.validate(:update_app_key, params) do
  #          # Break out the needed fields for the handler
  #          appId = Map.get(params, "id")
  #          key = Map.get(params, "key")
  #
  #          case Gateway.Router.Portal.Commands.Handler.Game.updateAppKey(appId, key) do
  #            :ok ->
  #              jsonRsp(conn, 200, %{ok: "ok"})
  #
  #            {:error, errorMessage} ->
  #              Logger.error(
  #                "[Gateway.Router.Service.V1.Receiver] Error update app key #{
  #                  inspect(errorMessage)
  #                }"
  #              )
  #
  #              jsonRsp(conn, 500, %{error: errorMessage})
  #          end
  #        else
  #          Logger.error(
  #            "[Gateway.Router.Service.V1.Receiver] Error Update key request schema violation #{
  #              inspect(params)
  #            }"
  #          )
  #
  #          jsonRsp(conn, 500, %{error: "unauthorized"})
  #        end
  #    end
  #  end
  #
  #  post "/:gameId/hook" do
  #    case conn.body_params do
  #      nil ->
  #        send_resp(conn, 422, "Missing boday parameters")
  #
  #      params ->
  #        if Gateway.Router.Portal.Commands.V1.Receiver.Schema.validate(:update_app_hook, params) do
  #          # Break out the needed fields for the handler
  #          appId = Map.get(params, "id")
  #          hook = Map.get(params, "hook")
  #
  #          case Gateway.Router.Portal.Commands.Handler.Game.updateAppHook(appId, hook) do
  #            :ok ->
  #              jsonRsp(conn, 200, %{ok: "ok"})
  #
  #            {:error, errorMessage} ->
  #              Logger.error(
  #                "[Gateway.Router.Service.V1.Receiver] Error update app hook #{
  #                  inspect(errorMessage)
  #                }"
  #              )
  #
  #              jsonRsp(conn, 500, %{error: errorMessage})
  #          end
  #        else
  #          Logger.error(
  #            "[Gateway.Router.Service.V1.Receiver] Error Update key request schema violation #{
  #              inspect(params)
  #            }"
  #          )
  #
  #          jsonRsp(conn, 500, %{error: "unauthorized"})
  #        end
  #    end
  #  end
  #
  #  post "/:gameId/meta" do
  #    case conn.body_params do
  #      nil ->
  #        send_resp(conn, 422, "Missing boday parameters")
  #
  #      params ->
  #        if Gateway.Router.Portal.Commands.V1.Receiver.Schema.validate(:update_app_meta, params) do
  #          # Break out the needed fields for the handler
  #          appId = Map.get(params, "id")
  #          meta = Map.get(params, "meta")
  #
  #          case Gateway.Router.Portal.Commands.Handler.Game.updateAppMeta(appId, meta) do
  #            :ok ->
  #              jsonRsp(conn, 200, %{ok: "ok"})
  #
  #            {:error, errorMessage} ->
  #              Logger.error(
  #                "[Gateway.Router.Service.V1.Receiver] Error update app Meta #{
  #                  inspect(errorMessage)
  #                }"
  #              )
  #
  #              jsonRsp(conn, 500, %{error: errorMessage})
  #          end
  #        else
  #          Logger.error(
  #            "[Gateway.Router.Service.V1.Receiver] Error Update Meta request schema violation #{
  #              inspect(params)
  #            }"
  #          )
  #
  #          jsonRsp(conn, 500, %{error: "unauthorized"})
  #        end
  #    end
  #  end

  match _ do
    Logger.error(
      "[Gateway.Router.Service.V1.Receiver] Unknown Request: #{inspect(conn.request_path)}"
    )

    send_resp(conn, 404, "Invalid PPS Route")
  end

  # ----------------------------------------------------------------------------
  # Private API
  # ---------------------------------------------------------------------------

  # defp jsonRsp(conn, status, obj) do
  #  put_resp_content_type(conn, "application/json")
  #  |> send_resp(status, Jason.encode!(obj))
  #  |> halt()
  # end

  # defp getHeaderValue(conn, val) do
  #  case conn |> get_req_header(val) do
  #    [val] -> val
  #    _ -> nil
  #  end
  # end
end
