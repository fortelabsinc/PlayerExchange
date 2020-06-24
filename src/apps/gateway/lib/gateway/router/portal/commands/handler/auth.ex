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
defmodule Gateway.Router.Portal.Commands.Handler.Auth do
  @moduledoc """
  For the most part we are just pushing these requests off to the
  storage module.  While one can argue that the storage module should
  not be responsible for such actions, AccessPass is a library used
  to do most of the auth actions.  AccessPass has both a mix of storage
  and business logic to manage auth.  As such we are just going to
  make use of this module however storage is main interface for it so ...
  """
  require Logger

  # ----------------------------------------------------------------------------
  # Public Auth APIs
  # ----------------------------------------------------------------------------

  @doc """
  Basic setup.  Nothing to do here
  """
  @spec init :: :ok
  def init() do
    :ok
  end

  @doc """
  A ping API to make sure the routing works
  """
  @spec ping :: <<_::32>>
  def ping() do
    "pong"
  end

  @doc """
  """
  @spec check(String.t()) :: {:error, <<_::160>>} | {:ok, map}
  def check(accessToken), do: Auth.check(accessToken)

  @doc """
  """
  @spec refresh(String.t()) :: {:error, <<_::160>>} | {:ok, map}
  def refresh(refreshToken), do: Auth.refresh(refreshToken)

  @doc """
  """
  @spec register(:invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}) ::
          {:error, <<_::200>> | %{optional(atom) => [binary]}} | {:ok, any}
  def register(data), do: Auth.register(data)

  @doc """
  """
  @spec confirm(any) :: {:error, <<_::200>>} | {:ok, any}
  def confirm(confirmId), do: Auth.confirm(confirmId)

  @doc """
  """
  @spec login(String.t(), String.t()) :: {:error, <<_::200, _::_*64>>} | {:ok, map}
  def login(username, password), do: Auth.login(username, password)

  @doc """
  """
  @spec logout(any) :: any
  def logout(accessToken), do: Auth.logout(accessToken)

  @doc """
  """
  @spec resetPassword(any) :: {:error, <<_::256>>} | {:ok, <<_::296>>}
  def resetPassword(user), do: Auth.resetPassword(user)

  @doc """
  """
  @spec changePassword(any, any, any) ::
          {:ok} | {:error, <<_::256>> | %{optional(atom) => [binary]}}
  def changePassword(id, pass, passConf), do: Auth.changePassword(id, pass, passConf)

  @doc """
  """
  @spec forgotUsername(any) :: {:error, <<_::152>>} | {:ok, <<_::256>>}
  def forgotUsername(email), do: Auth.forgotUsername(email)

  @doc """
  Read all names for a list of guild IDs
  """
  @spec names([String.t()]) :: {:ok, %{String.t() => String.t()}}
  def names(ids), do: Auth.names(ids)
end
