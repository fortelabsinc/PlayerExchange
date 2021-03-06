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
defmodule Auth do
  @moduledoc ~S"""
  """
  # import Utils.Build
  require Logger

  # ----------------------------------------------------------------------------
  # Public Auth APIs
  # ----------------------------------------------------------------------------

  @doc """
  Check to see if an access token is valid.

  Returns:

  {:ok, map} where map is
  ```
  %{
    email: <string email address>
    email_confirmed: <boolean>
    meta: map
    user_id: <string user_id>
    username: <string username>
  }
  ```
  """
  @spec check(String.t()) :: {:error, <<_::160>>} | {:ok, map}
  def check(accessToken), do: Storage.Auth.User.check(accessToken)

  @doc """
  Refreshes the given auth token
  """
  @spec refresh(String.t()) :: {:error, <<_::160>>} | {:ok, map}
  def refresh(refreshToken), do: Storage.Auth.User.refresh(refreshToken)

  @doc """
  """
  @spec register(:invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}) ::
          {:error, <<_::200>> | %{optional(atom) => [binary]}} | {:ok, any}
  # if_prod do
  #  def register(data), do: Storage.Auth.User.register(data)
  # else
  def register(data) do
    case Storage.Auth.User.registerDev(data) do
      {:error, _} = err ->
        err

      {:ok, _data, confirmId} ->
        confirm(confirmId)
    end
  end

  # end

  @doc """
  """
  @spec confirm(any) :: {:error, <<_::200>>} | {:ok, any}
  def confirm(confirmId) do
    rsp = Storage.Auth.User.confirm(confirmId)

    case rsp do
      {:ok, _data} ->
        # We need all the data for this guy.  Let's make
        # another pull
        info = Storage.Auth.User.queryByConfirmId(confirmId)

        {:ok, _} =
          Storage.Auth.User.userName(info)
          |> Blockchain.createAccount()

      err ->
        Logger.error("[Auth.confirm] Error: #{inspect(err)}")
    end

    rsp
  end

  @doc """
  """
  @spec login(String.t(), String.t()) :: {:error, <<_::200, _::_*64>>} | {:ok, map}
  def login(username, password) do
    case Storage.Auth.User.login(username, password) do
      {:ok, res} ->
        {:ok, Map.put(res, "payId", Blockchain.formatPayId(username))}

      err ->
        err
    end
  end

  @doc """
  """
  @spec logout(any) :: any
  def logout(accessToken), do: Storage.Auth.User.logout(accessToken)

  @doc """
  """
  @spec resetPassword(any) :: {:error, <<_::256>>} | {:ok, <<_::296>>}
  def resetPassword(user), do: Storage.Auth.User.resetPassword(user)

  @doc """
  """
  @spec changePassword(any, any, any) ::
          {:ok} | {:error, <<_::256>> | %{optional(atom) => [binary]}}
  def changePassword(id, pass, passConf), do: Storage.Auth.User.changePassword(id, pass, passConf)

  @doc """
  """
  @spec forgotUsername(any) :: {:error, <<_::152>>} | {:ok, <<_::256>>}
  def forgotUsername(email), do: Storage.Auth.User.forgotUserName(email)

  @doc """
  Look up a bunch of games names based on the passed in IDs
  """
  @spec names([String.t()]) ::
          {:ok, %{String.t() => String.t()}} | {:error, :not_found}
  def names(ids), do: Storage.userNames(ids)
end
