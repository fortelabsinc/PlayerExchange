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
defmodule Gateway.Router.Portal.Commands.Handler.Game do
  @moduledoc """
  Business logic processor for the request.  This module knows how to process
  and/or hand off the actual processing of the request
  """
  require Logger

  # ----------------------------------------------------------------------------
  # Public API
  # ----------------------------------------------------------------------------

  @doc """
  A basic init function for anything we want to make sure is setup before we
  start handling incoming requests
  """
  @spec init :: :ok
  def init() do
    :ok
  end

  @doc """
  A simple ping message
  """
  @spec ping :: <<_::32>>
  def ping(), do: "pong"

  #  @doc """
  #  Retister
  #  """
  #  @spec registerApp(String.t(), String.t(), String.t(), String.t()) ::
  #          {:ok, String.t()} | {:error, String.t()}
  #  def registerApp(name, hook, publicKey, email) do
  #    # Before we send this off to billing, lets double check
  #    # that the live user game us an HTTPS based endpoint
  #    if nil == hook or String.contains?(hook, "https://") do
  #      # Let's make sure this is valid RSA public key too
  #      if Utils.Crypto.RSA.valid?(publicKey) do
  #        Billing.registerApp(name, hook, publicKey, email, %{})
  #      else
  #        {:error, "Invalid RSA public key."}
  #      end
  #    else
  #      {:error, "Invalid Webhook API.  Must be https"}
  #    end
  #  end
  #
  #  @doc """
  #  Get the app info from the billing data
  #  """
  #  @spec getApp(String.t()) :: {:ok, map} | {:error, :not_found}
  #  def getApp(appId) do
  #    case Billing.app(appId) do
  #      {:ok, data} ->
  #        {:ok, stripAppInfo(data)}
  #
  #      {:error, _term} = err ->
  #        err
  #    end
  #  end
  #
  #  @doc """
  #  """
  #  @spec getAppsPage(integer, integer) :: {:ok, map} | {:error, :not_found}
  #  def getAppsPage(page, count) do
  #    case Billing.appsPage(page, count) do
  #      {:ok, data} ->
  #        data = Map.put(data, :list, Enum.map(data.list, fn item -> stripAppInfo(item) end))
  #        {:ok, data}
  #
  #      {:error, _term} = err ->
  #        err
  #    end
  #  end
  #
  #  @doc """
  #  Read all the apps
  #  """
  #  @spec getApps() :: {:ok, [map]}
  #  def getApps() do
  #    {:ok, data} = Billing.apps()
  #    # Strip out any of the data we don't want seen
  #    {:ok, Enum.map(data, fn entry -> stripAppInfo(entry) end)}
  #  end
  #
  #  @doc """
  #  Forward to the billing system to update the email field
  #  """
  #  @spec updateAppEmail(String.t(), String.t()) :: :ok | {:error, :update_failed}
  #  def updateAppEmail(appId, email) do
  #    case Billing.updateAppEmail(appId, email) do
  #      {:ok, _} -> :ok
  #      err -> err
  #    end
  #  end
  #
  #  @doc """
  #  Forward to the billing system to update the name field
  #  """
  #  @spec updateAppName(String.t(), String.t()) :: :ok | {:error, :update_failed}
  #  def updateAppName(appId, name) do
  #    case Billing.updateAppName(appId, name) do
  #      {:ok, _} -> :ok
  #      err -> err
  #    end
  #  end
  #
  #  @doc """
  #  Forward to the billing system to update the key field
  #  """
  #  @spec updateAppKey(String.t(), String.t()) ::
  #          :ok | {:error, :update_failed | :invalid_key_format}
  #  def updateAppKey(appId, key) do
  #    if Utils.Crypto.RSA.valid?(key) do
  #      case Billing.updateAppKey(appId, key) do
  #        {:ok, _} -> :ok
  #        err -> err
  #      end
  #    else
  #      {:error, :invalid_key_format}
  #    end
  #  end
  #
  #  @doc """
  #  Forward to the billing system to update the hook field
  #  """
  #  @spec updateAppHook(String.t(), String.t()) ::
  #          :ok | {:error, :update_failed | :invalid_webhook_format}
  #  def updateAppHook(appId, hook) do
  #    if nil == hook or String.contains?(hook, "https://") do
  #      case Billing.updateAppHook(appId, hook) do
  #        {:ok, _} -> :ok
  #        err -> err
  #      end
  #    else
  #      {:error, :invalid_webhook_format}
  #    end
  #  end
  #
  #  @doc """
  #  Forward to the billing system to update the meta field
  #  """
  #  @spec updateAppMeta(String.t(), map) :: :ok | {:error, :update_failed}
  #  def updateAppMeta(appId, meta) do
  #    case Billing.updateAppMeta(appId, meta) do
  #      {:ok, _} -> :ok
  #      err -> err
  #    end
  #  end
  #
  #  @doc """
  #  Remove an App from the system
  #  """
  #  @spec removeApp(String.t()) :: :ok
  #  def removeApp(appId), do: Billing.removeApp(appId)
  #
  #  # ----------------------------------------------------------------------------
  #  # Private API
  #  # ----------------------------------------------------------------------------
  #
  #  defp stripAppInfo(data) do
  #    Map.delete(data, :public)
  #    |> Map.delete(:internal)
  #    |> Map.delete(:external)
  #  end
end
